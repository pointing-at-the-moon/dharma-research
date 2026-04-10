#!/usr/bin/env python3
"""
check_paper_format.py — Pre-commit structural audit for dharma-research CN papers.

Scope (the two items that historically slip past the manual checklist):
  1. Bilingual abstract structure on Chinese papers
  2. ASCII punctuation drift inside Chinese text

Both checks ONLY run on Chinese papers (filename contains CJK chars). Everything
else in the publication checklist (footer, footnote orphans, cross-ref index,
author format, etc.) is still handled manually.

Usage:
    python scripts/check_paper_format.py              # check git-staged .md files (default)
    python scripts/check_paper_format.py --all        # audit entire papers/ directory
    python scripts/check_paper_format.py a.md b.md    # check specific files
    python scripts/check_paper_format.py --fix        # auto-fix punctuation issues in scope
    python scripts/check_paper_format.py --all --fix  # mass-fix punctuation across corpus

Exit code: 0 = clean, 1 = issues found.

Install as a git pre-commit hook:
    ln -sf ../../scripts/check_paper_format.py .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
"""
from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys

# Unicode ranges
CJK_CHAR = r"\u4e00-\u9fff"                      # CJK unified ideographs
CJK_PUNCT = r"\u3000-\u303f"                     # CJK symbols & punctuation
CJK_FULLWIDTH = r"\uff00-\uffef"                 # fullwidth forms
CJK_ADJACENT = CJK_CHAR + CJK_PUNCT + CJK_FULLWIDTH

HAS_CJK = re.compile(f"[{CJK_CHAR}]")
CJK_ONLY = re.compile(f"[{CJK_CHAR}]")

# Skip patterns (lines we don't audit)
SKIP_PREFIXES = ("|", "[^", "#", ">", "- [", "* [", "```")
SKIP_SUBSTRINGS = ("CBETA", "GitHub", "github.com")
SKIP_PATTERNS = [re.compile(r"T\d{4}"), re.compile(r"https?://")]

# Structural checks for CN papers
ABSTRACT_HEADER = re.compile(r"^##\s*摘要(\s+Abstract)?\s*$", re.MULTILINE)
KEYWORDS_LINE = re.compile(r"^\*\*關鍵詞(\s+Keywords)?[：:]?\*\*.*$", re.MULTILINE)


def is_chinese_paper(path: pathlib.Path) -> bool:
    """A paper is 'Chinese' if its filename contains CJK characters."""
    return bool(HAS_CJK.search(path.name))


def line_is_skippable(line: str) -> bool:
    s = line.strip()
    if not s:
        return True
    if s.startswith(SKIP_PREFIXES):
        return True
    if any(sub in s for sub in SKIP_SUBSTRINGS):
        return True
    if any(p.search(s) for p in SKIP_PATTERNS):
        return True
    return False


def line_cjk_ratio(line: str) -> float:
    """Fraction of non-whitespace chars that are CJK. 0.0 if empty."""
    stripped = re.sub(r"\s", "", line)
    if not stripped:
        return 0.0
    cjk = len(CJK_ONLY.findall(stripped))
    return cjk / len(stripped)


# ---------------------------------------------------------------------------
# Check 1: bilingual abstract structure
# ---------------------------------------------------------------------------
def check_bilingual_abstract(path: pathlib.Path, content: str) -> list[str]:
    """Return a list of issue strings for the bilingual-abstract check."""
    issues: list[str] = []

    # 1a. Header must be `## 摘要 Abstract`
    m = ABSTRACT_HEADER.search(content)
    if not m:
        issues.append("no `## 摘要` header found")
        return issues
    if "Abstract" not in m.group(0):
        issues.append("abstract header is `## 摘要` — should be `## 摘要 Abstract`")

    # 1b. Abstract block: extract text between header and next `**關鍵詞` / `---`
    header_end = m.end()
    tail = content[header_end:]
    end_m = re.search(r"^(\*\*關鍵詞|---\s*$)", tail, re.MULTILINE)
    abstract_body = tail[: end_m.start()] if end_m else tail

    # Split into paragraphs (blank-line separated)
    paras = [p.strip() for p in re.split(r"\n\s*\n", abstract_body) if p.strip()]

    has_cn_para = False
    has_en_para = False
    for p in paras:
        clean = re.sub(r"\s", "", p)
        if len(clean) < 100:
            continue  # too short to count as a real abstract paragraph
        ratio = line_cjk_ratio(p)
        if ratio > 0.5:
            has_cn_para = True
        elif ratio < 0.15:
            has_en_para = True

    if not has_cn_para:
        issues.append("no Chinese abstract paragraph (≥100 chars, >50% CJK)")
    if not has_en_para:
        issues.append("no English abstract paragraph (≥100 chars, <15% CJK)")

    # 1c. Keywords line must be bilingual: `**關鍵詞 Keywords:** ... / ...`
    kw_m = KEYWORDS_LINE.search(content)
    if not kw_m:
        issues.append("no `**關鍵詞**` line found")
    else:
        kw_line = kw_m.group(0)
        if "Keywords" not in kw_line:
            issues.append("keywords line missing `Keywords` label (should be `**關鍵詞 Keywords:**`)")
        if "/" not in kw_line:
            issues.append("keywords line missing `/` separator between CN and EN terms")

    return issues


# ---------------------------------------------------------------------------
# Check 2: ASCII punctuation drift in Chinese text
# ---------------------------------------------------------------------------
PUNCT_ADJACENT_CJK = re.compile(
    f"(?<=[{CJK_ADJACENT}])[,;:]|[,;:](?=[{CJK_CHAR}])"
)
MISMATCH_FULL_OPEN_ASCII_CLOSE = re.compile(r"（[^（）()\n]{0,80}\)")
MISMATCH_ASCII_OPEN_FULL_CLOSE = re.compile(
    f"(?<=[{CJK_ADJACENT}])\\([^（）()\\n]{{0,80}}）"
)


def check_punctuation(path: pathlib.Path, content: str) -> list[tuple[int, str]]:
    """Return (line_number, description) tuples for punctuation drift."""
    findings: list[tuple[int, str]] = []
    for i, line in enumerate(content.split("\n"), 1):
        if line_is_skippable(line):
            continue
        if line_cjk_ratio(line) < 0.2:
            continue  # predominantly English line — skip

        ascii_punct = PUNCT_ADJACENT_CJK.findall(line)
        mismatch1 = MISMATCH_FULL_OPEN_ASCII_CLOSE.findall(line)
        mismatch2 = MISMATCH_ASCII_OPEN_FULL_CLOSE.findall(line)

        if ascii_punct:
            findings.append(
                (i, f"ASCII punct adjacent to CJK: {sorted(set(ascii_punct))}")
            )
        if mismatch1 or mismatch2:
            samples = (mismatch1 + mismatch2)[:3]
            findings.append((i, f"mismatched bracket pair: {samples}"))
    return findings


def fix_punctuation(content: str) -> tuple[str, int]:
    """Auto-fix punctuation drift. Returns (new_content, change_count)."""
    new_lines: list[str] = []
    changes = 0
    for line in content.split("\n"):
        if line_is_skippable(line) or line_cjk_ratio(line) < 0.2:
            new_lines.append(line)
            continue

        orig = line
        # ASCII → fullwidth punctuation adjacent to CJK
        line = re.sub(f"(?<=[{CJK_ADJACENT}]),", "，", line)
        line = re.sub(f",(?=[{CJK_CHAR}])", "，", line)
        line = re.sub(f"(?<=[{CJK_ADJACENT}]);", "；", line)
        line = re.sub(f";(?=[{CJK_CHAR}])", "；", line)
        line = re.sub(f"(?<=[{CJK_ADJACENT}]):(?!/)", "：", line)
        line = re.sub(f":(?=[{CJK_CHAR}])", "：", line)
        # Bracket pairs: make both sides fullwidth
        line = re.sub(r"（([^（）()\n]{0,80})\)", r"（\1）", line)
        line = re.sub(
            f"(?<=[{CJK_ADJACENT}])\\(([^（）()\\n]{{0,80}})）", r"（\1）", line
        )
        if line != orig:
            changes += 1
        new_lines.append(line)
    return "\n".join(new_lines), changes


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def audit_file(path: pathlib.Path, fix: bool = False) -> int:
    """Audit one CN paper. Returns issue count. EN papers are skipped entirely."""
    if not is_chinese_paper(path):
        return 0  # checks only apply to Chinese papers

    try:
        content = path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError) as e:
        print(f"{path}: ERROR reading file: {e}", file=sys.stderr)
        return 1

    issues_count = 0

    # Bilingual abstract check
    abstract_issues = check_bilingual_abstract(path, content)
    for issue in abstract_issues:
        print(f"{path}: [abstract] {issue}")
        issues_count += 1

    # Punctuation check (or fix)
    if fix:
        new_content, changes = fix_punctuation(content)
        if changes:
            path.write_text(new_content, encoding="utf-8")
            print(f"{path}: [punct] auto-fixed {changes} line(s)")
    else:
        punct_issues = check_punctuation(path, content)
        for line_no, desc in punct_issues:
            print(f"{path}:L{line_no}: [punct] {desc}")
            issues_count += 1

    return issues_count


def staged_markdown_files() -> list[pathlib.Path]:
    """Return markdown files staged in git (added/copied/modified).

    Uses `-z` to get NUL-delimited raw paths — otherwise git quotes filenames
    containing CJK characters (e.g. `"papers/S7-P07_\\350\\241\\243..."`) and
    pathlib can't find them.
    """
    try:
        out = subprocess.check_output(
            [
                "git", "diff", "--cached", "--name-only",
                "--diff-filter=ACM", "-z",
            ],
            text=True,
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        return []
    return [
        pathlib.Path(name)
        for name in out.split("\0")
        if name.endswith(".md")
    ]


def gather_paths(args: argparse.Namespace) -> list[pathlib.Path]:
    """Resolve CLI args to a concrete list of .md file paths."""
    if args.all:
        return sorted(pathlib.Path("papers").rglob("*.md"))

    if args.paths:
        paths: list[pathlib.Path] = []
        for arg in args.paths:
            p = pathlib.Path(arg)
            if p.is_dir():
                paths.extend(sorted(p.rglob("*.md")))
            elif p.is_file() and p.suffix == ".md":
                paths.append(p)
            else:
                print(f"warning: {arg} is not a .md file or directory", file=sys.stderr)
        return paths

    # Default: staged files from git
    return [p for p in staged_markdown_files() if p.exists()]


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Structural audit for dharma-research CN papers."
    )
    parser.add_argument(
        "paths",
        nargs="*",
        help="files or directories to check (default: git-staged .md files)",
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="audit the entire papers/ directory (for periodic full audits)",
    )
    parser.add_argument(
        "--fix",
        action="store_true",
        help="auto-fix punctuation issues in place (abstract issues are never auto-fixed)",
    )
    args = parser.parse_args()

    paths = gather_paths(args)
    if not paths:
        # No staged files, no explicit paths — nothing to do. Exit clean.
        print("no .md files to check (no git-staged changes; use --all for full audit)")
        return 0

    total_issues = 0
    checked = 0
    for path in paths:
        if is_chinese_paper(path):
            checked += 1
        total_issues += audit_file(path, fix=args.fix)

    if total_issues == 0:
        print(f"✅ {checked} CN paper(s) checked, no issues")
        return 0
    else:
        print(f"\n❌ {total_issues} issue(s) across {checked} CN paper(s)")
        return 1


if __name__ == "__main__":
    sys.exit(main())

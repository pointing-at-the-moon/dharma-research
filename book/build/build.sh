#!/bin/bash
# 指月八部曲——從初發心到海印三昧
# Pandoc 編譯腳本 · M0 骨架
#
# 用法:
#   cd book/
#   ./build/build.sh         # 產出 PDF / EPUB / LaTeX 三種格式
#   ./build/build.sh pdf     # 只產 PDF
#   ./build/build.sh epub    # 只產 EPUB
#   ./build/build.sh tex     # 只產 LaTeX
#
# 依賴:
#   - pandoc (brew install pandoc)
#   - xelatex (MacTeX / BasicTeX + collection-xetex)
#   - 字體: Noto Serif CJK TC / Noto Sans CJK TC

set -euo pipefail

# 由 book/ 執行;腳本位於 book/build/
BOOK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$BOOK_ROOT"

OUTPUT_DIR="build/output"
METADATA="build/metadata.yaml"
mkdir -p "$OUTPUT_DIR"

# 章節收集順序(BOOK_PLAN §五 / §六)
# 注意:parts/ 與 transitions/ 的 .md 檔案會依檔名字母序 glob 進來,
# 因此檔名必須編號(例如 parts/01_信/01_*.md, 02_*.md ...)
#
# M0 階段只有總序可以編譯;其餘章節陸續加入。

collect_inputs() {
  local inputs=()
  inputs+=("00_總序.md")

  # 導讀地圖(若存在)
  if [ -f "00_導讀地圖.md" ]; then
    inputs+=("00_導讀地圖.md")
  fi

  # 八部 + 過渡章交錯
  local parts=(01_信 02_解 03_行 04_問 05_切 06_照 07_攝 08_顯)
  local trans=(01_從信到解 02_從解到行 03_從行到問 04_從問到切 05_從切到照 06_從照到攝 07_從攝到顯)

  for i in "${!parts[@]}"; do
    local part="${parts[$i]}"
    if compgen -G "parts/$part/*.md" > /dev/null; then
      inputs+=(parts/"$part"/*.md)
    fi
    if [ $i -lt ${#trans[@]} ]; then
      local t="transitions/${trans[$i]}.md"
      if [ -f "$t" ]; then
        inputs+=("$t")
      fi
    fi
  done

  # 終章
  if [ -f "99_終章.md" ]; then
    inputs+=("99_終章.md")
  fi

  # 附錄
  if compgen -G "appendix/*.md" > /dev/null; then
    inputs+=(appendix/*.md)
  fi

  printf '%s\n' "${inputs[@]}"
}

INPUTS=()
while IFS= read -r line; do
  INPUTS+=("$line")
done < <(collect_inputs)

echo "📖 收集章節:${#INPUTS[@]} 檔"

build_pdf() {
  echo "→ 產出 PDF"
  pandoc \
    --metadata-file="$METADATA" \
    --toc --toc-depth=2 \
    --top-level-division=part \
    --pdf-engine=xelatex \
    -V CJKmainfont="Noto Serif CJK TC" \
    -V mainfont="Noto Serif CJK TC" \
    -V sansfont="Noto Sans CJK TC" \
    -V monofont="Menlo" \
    -V geometry:margin=2.5cm \
    -V linestretch=1.4 \
    -o "$OUTPUT_DIR/指月八部曲.pdf" \
    "${INPUTS[@]}"
}

build_epub() {
  echo "→ 產出 EPUB"
  pandoc \
    --metadata-file="$METADATA" \
    --toc --toc-depth=2 \
    --top-level-division=part \
    -o "$OUTPUT_DIR/指月八部曲.epub" \
    "${INPUTS[@]}"
}

build_tex() {
  echo "→ 產出 LaTeX"
  pandoc \
    --metadata-file="$METADATA" \
    --toc --toc-depth=2 \
    --top-level-division=part \
    -s \
    -o "$OUTPUT_DIR/指月八部曲.tex" \
    "${INPUTS[@]}"
}

case "${1:-all}" in
  pdf)  build_pdf ;;
  epub) build_epub ;;
  tex)  build_tex ;;
  all)
    build_pdf
    build_epub
    build_tex
    ;;
  *)
    echo "用法: $0 [pdf|epub|tex|all]" >&2
    exit 1
    ;;
esac

echo "✅ 編譯完成 → $OUTPUT_DIR/"
ls -lh "$OUTPUT_DIR/"

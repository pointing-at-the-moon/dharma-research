#!/bin/bash
# ============================================================
# 指月 Dharma Research — Paper #13 RAG Queries
# 行深——朝內，深入行蘊
# Going Deep: Inward, Into the Formations
#
# Run on local M5 Max with AnythingLLM + Ollama Qwen 3.5
# chmod +x rag_paper13.sh && ./rag_paper13.sh
# ============================================================

# --- CONFIGURE THESE ---
API_KEY="${ANYTHINGLLM_API_KEY:-your-api-key-here}"
WORKSPACE="${ANYTHINGLLM_WORKSPACE:-tripitaka}"
BASE_URL="${ANYTHINGLLM_URL:-http://localhost:3001/api}"
MODE="query"  # Try "chat" if "query" returns 500
# -----------------------

OUTPUT="${1:-paper13_rag_results.md}"

SYSTEM_PROMPT="你是大正藏經論檢索助手。請直接引用原典經文，標明出處（經名、卷數、大正藏冊號與編號）。只引原文，不要解釋或詮釋。如果找不到直接相關的經文，請說明。"

# --- QUERIES ---
declare -a QUERIES=(
  "窺基《般若波羅蜜多心經幽贊》卷一中，解釋「行深般若波羅蜜多時」的完整段落。請引用「行謂進行」開始的原文，包括「深有二種」的完整論述。"

  "《成唯識論》中五重唯識觀的完整論述。包括：遣虛存實、捨濫留純、攝末歸本、隱劣顯勝、遣相證性五個層次的原文。"

  "行蘊（samskara、行）在《瑜伽師地論》中的定義。特別是思心所與行蘊的關係，以及行蘊如何與阿賴耶識種子相互作用。請引用原文。"

  "《大智度論》中「五波羅蜜如盲，般若波羅蜜如眼」的完整段落。說明般若為六度之眼、統攝五度的義理。包含卷數與出處。"

  "《成唯識論》或《瑜伽師地論》中，關於唯識修道五位的論述：資糧位、加行位、通達位（見道位）、修習位、究竟位。特別是從加行位到通達位（見道位）的關鍵轉折——四尋思、四如實智的原文。"

  "窺基《般若波羅蜜多心經幽贊》中對「時」字的解釋。「行深般若波羅蜜多時」的「時」是什麼意義？是過去某個時間還是當下？請引用原文。"

  "《成唯識論》中關於思心所（cetanā）的定義，以及思心所如何造作業種子、薰習阿賴耶識。特別是思心所與行蘊的關係——「造作為性」的完整原文。"
)

declare -a LABELS=(
  "Q1: 窺基《幽贊》行深段完整原文"
  "Q2: 五重唯識觀完整論述"
  "Q3: 行蘊（samskara）在瑜伽師地論的定義"
  "Q4: 大智度論——般若為六度之眼"
  "Q5: 唯識修道五位——加行位到通達位的關鍵轉折"
  "Q6: 窺基《幽贊》對「時」字的解釋"
  "Q7: 思心所（cetanā）造作業種子——行蘊與阿賴耶識"
)
# --- END QUERIES ---

# ============================================================
# Preflight check
# ============================================================
if [ "$API_KEY" = "your-api-key-here" ]; then
  echo "❌ Please set API_KEY in this script or export ANYTHINGLLM_API_KEY"
  exit 1
fi

# Verify workspace exists
echo "🔍 Checking workspace '$WORKSPACE'..."
WS_CHECK=$(curl -s -H "Authorization: Bearer ${API_KEY}" \
  "${BASE_URL}/v1/workspaces" 2>&1)

if echo "$WS_CHECK" | jq -e ".workspaces[] | select(.slug == \"$WORKSPACE\")" > /dev/null 2>&1; then
  echo "  ✓ Workspace found"
else
  echo "  ❌ Workspace '$WORKSPACE' not found. Available:"
  echo "$WS_CHECK" | jq -r '.workspaces[].slug' 2>/dev/null
  exit 1
fi

# ============================================================
# Run queries
# ============================================================

echo "# Paper #13 RAG Results — $(date '+%Y-%m-%d %H:%M')" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## 行深——朝內，深入行蘊" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "Source: AnythingLLM local RAG (大正藏/CBETA)" >> "$OUTPUT"
echo "Model: Ollama Qwen 3.5" >> "$OUTPUT"
echo "Workspace: $WORKSPACE" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "" >> "$OUTPUT"

total=${#QUERIES[@]}
success=0
fail=0

for i in "${!QUERIES[@]}"; do
  idx=$((i + 1))
  echo ""
  echo "[$idx/$total] ${LABELS[$i]}..."

  echo "## ${LABELS[$i]}" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  PAYLOAD=$(jq -n \
    --arg msg "${QUERIES[$i]}" \
    --arg sys "$SYSTEM_PROMPT" \
    --arg mode "$MODE" \
    '{
      message: $msg,
      mode: $mode,
      systemPrompt: $sys
    }')

  RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
    "${BASE_URL}/v1/workspace/${WORKSPACE}/chat" \
    -H "Authorization: Bearer ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" 2>&1)

  HTTP_CODE=$(echo "$RESPONSE" | tail -1)
  BODY=$(echo "$RESPONSE" | sed '$d')

  if [ "$HTTP_CODE" != "200" ]; then
    echo "  ❌ HTTP $HTTP_CODE"
    echo "⚠️ HTTP $HTTP_CODE error. Raw response:" >> "$OUTPUT"
    echo '```' >> "$OUTPUT"
    echo "$BODY" | head -c 500 >> "$OUTPUT"
    echo '```' >> "$OUTPUT"
    fail=$((fail + 1))
  else
    TEXT=$(echo "$BODY" | jq -r '.textResponse // "null"' 2>/dev/null)
    if [ -z "$TEXT" ] || [ "$TEXT" = "null" ]; then
      echo "  ⚠️ Empty response"
      echo "⚠️ Empty response. Raw:" >> "$OUTPUT"
      echo '```' >> "$OUTPUT"
      echo "$BODY" | head -c 500 >> "$OUTPUT"
      echo '```' >> "$OUTPUT"
      fail=$((fail + 1))
    else
      echo "$TEXT" >> "$OUTPUT"
      echo "  ✓ Done ($(echo "$TEXT" | wc -c | tr -d ' ') bytes)"
      success=$((success + 1))
    fi
  fi

  echo "" >> "$OUTPUT"
  echo "---" >> "$OUTPUT"
  echo "" >> "$OUTPUT"

  sleep 2
done

echo ""
echo "============================================"
echo "✅ Complete: $success/$total succeeded, $fail failed"
echo "📄 Results: $OUTPUT"
if [ $fail -gt 0 ]; then
  echo ""
  echo "💡 If you got 500 errors, try:"
  echo "   1. Change MODE=\"chat\" at top of script"
  echo "   2. Check workspace slug matches exactly"
  echo "   3. Check ~/.anythingllm/logs/ for details"
fi
echo "============================================"

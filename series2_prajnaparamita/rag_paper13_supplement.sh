#!/bin/bash
# ============================================================
# 指月 Dharma Research — Paper #13 RAG Queries (Supplement)
# 行深——朝內，深入行蘊 (追加查詢)
#
# 追加 4 條查詢：觀世音慈悲、八地不動地、想蘊→行蘊轉化的經典記載
# Run AFTER rag_paper13.sh
# ============================================================

# --- CONFIGURE THESE ---
API_KEY="${ANYTHINGLLM_API_KEY:-your-api-key-here}"
WORKSPACE="${ANYTHINGLLM_WORKSPACE:-tripitaka}"
BASE_URL="${ANYTHINGLLM_URL:-http://localhost:3001/api}"
MODE="query"
# -----------------------

OUTPUT="${1:-paper13_rag_supplement.md}"

SYSTEM_PROMPT="你是大正藏經論檢索助手。請直接引用原典經文，標明出處（經名、卷數、大正藏冊號與編號）。只引原文，不要解釋或詮釋。如果找不到直接相關的經文，請說明。"

# --- QUERIES ---
declare -a QUERIES=(
  "觀世音菩薩在經典中如何描述自己的慈悲？是否有經文記載觀世音菩薩說自己並不覺得在行慈悲，或者慈悲已成自然？請從《大悲心陀羅尼經》《華嚴經》《法華經普門品》《楞嚴經》觀世音菩薩耳根圓通章中查找相關段落。"

  "八地菩薩（不動地）在《成唯識論》《華嚴經十地品》《十地經論》《瑜伽師地論》中的特徵描述。特別是：八地菩薩為何稱為『不動地』？八地菩薩的無功用行（anābhoga）是什麼意思？是否意味著不需刻意而自然利益眾生？請引用原文。"

  "從初地到八地，菩薩的慈悲心如何變化？《十地經論》或《華嚴經十地品》中是否有描述菩薩在不同地的利他行為從有功用到無功用的轉變？特別是第七地（遠行地）到第八地（不動地）之間的質變。請引用原文。"

  "《成唯識論》中關於種子從有漏到無漏的轉變機制。特別是：無漏種子如何在修行過程中逐漸增長？有漏種子如何逐漸減弱？這個『轉染成淨』的過程在五位中對應哪些階段？請引用原文。"
)

declare -a LABELS=(
  "Q8: 觀世音菩薩自述慈悲——大悲心陀羅尼經/法華/楞嚴/華嚴"
  "Q9: 八地不動地——無功用行的經論定義"
  "Q10: 初地到八地慈悲的質變——有功用到無功用"
  "Q11: 種子轉染成淨的五位機制"
)
# --- END QUERIES ---

# ============================================================
# Preflight check
# ============================================================
if [ "$API_KEY" = "your-api-key-here" ]; then
  echo "❌ Please set API_KEY in this script or export ANYTHINGLLM_API_KEY"
  exit 1
fi

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

echo "# Paper #13 RAG Supplement — $(date '+%Y-%m-%d %H:%M')" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "## 追加查詢：觀世音慈悲 + 八地不動地 + 種子轉化" >> "$OUTPUT"
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

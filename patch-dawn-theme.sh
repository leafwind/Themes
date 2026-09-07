#!/bin/bash
# patch-dawn-theme.sh
# 直接 patch 原始主題，套用所有客製化

set -e

DAWN_DIR=./packages/dawn

echo ">>> 開始 patch"

# ── fix 1: 中文檔名縮圖，直接用原圖
echo ">>> fix 1: srcset 直接用原圖"
printf '{{feature_image}}\n' > "$DAWN_DIR/partials/srcset.hbs"

# ── fix 2: 日期格式改為 YYYY-MM-DD，移除月份欄位
echo ">>> fix 2: 日期格式 YYYY-MM-DD"
sed -i '' 's/{{date published_at format="DD"}}/{{date published_at format="YYYY-MM-DD"}}/' \
    $DAWN_DIR/partials/loop.hbs

sed -i '' '/<div class="feed-calendar-month">/,/<\/div>/d' \
    $DAWN_DIR/partials/loop.hbs

# ── fix 3: 移除 content.hbs 的 feature image 區塊
echo ">>> fix 3: 移除 content.hbs feature image 區塊"
# 先移除內層
sed -i '' '/<figure class="single-media/,/<\/figure>/d' "$DAWN_DIR/partials/content.hbs"
# 這樣移除外層的時候才不會 match 到內層的 if 區塊
sed -i '' '/{{#if feature_image}}/,/{{\/if}}/d' "$DAWN_DIR/partials/content.hbs"

# ── fix 4: 設定每頁文章數
echo ">>> fix 4: 設定 posts_per_page"
sed -i '' 's/"posts_per_page": [0-9]*/"posts_per_page": 20/' \
    "$DAWN_DIR/package.json"

# ── fix 5: 橫式縮圖框比例 2:1 → 3:2（精選文章輪播、標籤頁頭圖共用）
echo ">>> fix 5: 橫式縮圖框改 3:2"
# deploy-theme.sh 不會重跑 build，所以編譯後的 screen.css 也要一起改
sed -i '' 's/padding-bottom: 50%;/padding-bottom: 66.666%;/' \
    "$DAWN_DIR/assets/css/misc/utils.css"
sed -i '' 's/\.u-placeholder\.horizontal:before{padding-bottom:50%}/.u-placeholder.horizontal:before{padding-bottom:66.666%}/' \
    "$DAWN_DIR/assets/built/screen.css"

echo ">>> 完成！記得到後台重新啟用 dawn-custom 主題。"

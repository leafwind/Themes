set -e
echo ">>> 開始 patch"

cd /opt/Themes/
git pull
cp -r packages/dawn /opt/ghost/data/ghost/themes/
echo ">>> 完成！請到Ghost 後台重新啟用主題，可能需要重啟 docker: `docker restart ghost-ghost-1`"

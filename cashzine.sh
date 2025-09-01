#!/data/data/com.termux/files/usr/bin/bash

EMAIL_FILE="gmail.txt"

if [ ! -f "$EMAIL_FILE" ]; then
    echo "❌ File $EMAIL_FILE không tồn tại!"
    exit 1
fi

LINE=1
TOTAL=$(wc -l < "$EMAIL_FILE")

echo "Nhấn Enter để reset Cashzine + đổi Android ID + copy Gmail + mở app."
echo "Ctrl+C để thoát."

while [ $LINE -le $TOTAL ]; do
    read -p ""

    su -c "pm clear com.sky.sea.cashzine"

    NEW_ID=$(cat /proc/sys/kernel/random/uuid | tr -d '-' | cut -c1-16)

    su -c "settings put secure android_id $NEW_ID"

    su -c "pm grant com.sky.sea.cashzine android.permission.READ_EXTERNAL_STORAGE"
    su -c "pm grant com.sky.sea.cashzine android.permission.WRITE_EXTERNAL_STORAGE"

    EMAIL=$(sed -n "${LINE}p" "$EMAIL_FILE")
    termux-clipboard-set "$EMAIL"

    su -c "monkey -p com.sky.sea.cashzine -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1"

    echo "Android ID mới: $NEW_ID"
    echo "Gmail đã copy: $EMAIL"
    echo "Cashzine đã được mở."

    LINE=$((LINE+1))
done

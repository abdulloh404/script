#!/bin/bash

# โหลด nvm
. ~/.nvm/nvm.sh

# ตรวจสอบว่า nvm ถูกโหลดสำเร็จ
if [ -z "$NVM_DIR" ]; then
    echo "Error: NVM is not loaded. Please ensure NVM is installed and configured properly."
    exit 1
fi

# ตรวจสอบว่า Node.js มีเวอร์ชันที่ถูกเลือกใน nvm
CURRENT_VERSION=$(nvm version)
if [ "$CURRENT_VERSION" == "N/A" ]; then
    echo "Error: No Node.js version is currently selected in NVM."
    exit 1
fi

# กำหนดตำแหน่งไฟล์ต้นทางและปลายทาง
DIR=$NVM_DIR/versions/node/$CURRENT_VERSION/bin/*
DEST=/usr/local/bin

# ลบ symbolic links เก่าที่เกี่ยวข้องกับ Node.js
echo "Removing old symbolic links in $DEST..."
for filename in node npm npx; do
    if [ -L "$DEST/$filename" ]; then
        echo "Removing old link: $DEST/$filename"
        sudo rm "$DEST/$filename"
    fi
done

# อัปเดต symbolic links
echo "Creating new symbolic links for Node.js version $CURRENT_VERSION..."
for filepath in $DIR; do
    filename=$(basename "$filepath")
    DEST_FILE=$DEST/$filename
    echo "Linking $filename to $DEST_FILE"
    sudo ln -sf "$filepath" "$DEST_FILE"
done

echo "Node.js version $CURRENT_VERSION has been updated in $DEST."

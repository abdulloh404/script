#!/bin/bash

# ตรวจสอบให้แน่ใจว่าอยู่ใน directory ของ git repo
if [ ! -d ".git" ]; then
  echo "This is not a git repository!"
  exit 1
fi

# เพิ่มไฟล์ที่มีการเปลี่ยนแปลงทั้งหมด
git add .

# ตรวจสอบให้แน่ใจว่าได้ระบุข้อความ commit
COMMIT_MSG=$1
if [ -z "$COMMIT_MSG" ]; then
  echo "Please provide a commit message."
  exit 1
fi

# ทำการ commit
git commit -m "$COMMIT_MSG"

# ทำการ push ไปยัง remote
git push origin $(git rev-parse --abbrev-ref HEAD)

# แจ้งเตือนการทำงานเสร็จสิ้น
echo "Changes committed and pushed successfully!"

#!/bin/bash

# 取得當前的 Git 分支名稱
current_branch=$(git symbolic-ref --short HEAD)

# 印出分支名稱
echo "當前的 Git 分支：$current_branch"

# 詢問使用者是否確定要執行 git push
read -p "是否確定要執行 git push (Y/n)？" confirm

# 如果使用者輸入的是 Y 或 y，就執行 git push
if [[ $confirm == "Y" || $confirm == "y" ]]; then
  git push -f origin "$current_branch"
  git fetch
else
  echo "已取消執行 git push。"
fi

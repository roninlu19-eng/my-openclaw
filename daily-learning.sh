#!/bin/bash
# /home/admin/.openclaw/workspace/daily-learning.sh

set -e  # 遇错即停

TODAY=$(date +%Y-%m-%d)
LOG_FILE="/home/admin/.openclaw/workspace/memory/$TODAY.md"
LEARNING_FILE="/home/admin/.openclaw/workspace/learnings/$TODAY.md"
MEMORY_FILE="/home/admin/.openclaw/workspace/MEMORY.md"

# 创建 learnings 目录（如果不存在）
mkdir -p /home/admin/.openclaw/workspace/learnings

# 检查日志文件是否存在
if [ ! -f "$LOG_FILE" ]; then
    echo "[$(date)] 日志文件 $LOG_FILE 不存在，跳过今日学习总结。" >> /home/admin/.openclaw/workspace/cron.log
    exit 0
fi

# 提取内容（示例：按关键词提取）
echo "# $(date +%Y-%m-%d) 学习总结" > "$LEARNING_FILE"
echo "" >> "$LEARNING_FILE"

grep -E "^(### 技术知识|### 踩坑记录|### 经验教训)" "$LOG_FILE" >> "$LEARNING_FILE" || echo "未找到相关记录。" >> "$LEARNING_FILE"

# 更新 MEMORY.md（示例：追加到末尾）
echo "" >> "$MEMORY_FILE"
echo "## $(date +%Y-%m-%d) 学习摘要" >> "$MEMORY_FILE"
echo "- $(grep -E "^- " "$LEARNING_FILE" | head -n 5 | sed 's/^/- /g')" >> "$MEMORY_FILE"

# Git 操作
cd /home/admin/.openclaw/workspace
git add .
git commit -m "daily: 自动更新学习总结和长期记忆 ($TODAY)"
git push origin main

echo "[$(date)] 学习总结已生成并提交至 Git。" >> /home/admin/.openclaw/workspace/cron.log
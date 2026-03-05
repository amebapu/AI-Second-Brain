#!/bin/bash
# setup-server.sh — 云服务器一键初始化脚本
# 使用前请修改下面的变量

set -e

# ============ 请修改以下变量 ============
GITHUB_REPO="git@github.com:你的用户名/shared-vault.git"  # ← 改成你的仓库地址
# ========================================

VAULT_DIR="$HOME/shared-vault"

echo "=== Step 1: 克隆 vault 仓库 ==="
if [ ! -d "$VAULT_DIR" ]; then
    git clone "$GITHUB_REPO" "$VAULT_DIR"
    echo "✅ 已 clone vault 仓库"
else
    echo "⚠️ vault 目录已存在，跳过 clone"
fi

echo "=== Step 2: 配置 Git ==="
cd "$VAULT_DIR"
git config user.name "server-agent"
git config user.email "server@agent.local"
git config pull.rebase true
echo "✅ Git 配置完成"

echo "=== Step 3: 同步脚本赋权 ==="
chmod +x "$VAULT_DIR/scripts/vault-sync.sh"
echo "✅ 同步脚本已赋权"

echo "=== Step 4: 配置 Cron 定时同步 ==="
CRON_JOB="*/5 * * * * $VAULT_DIR/scripts/vault-sync.sh auto >> /tmp/vault-sync.log 2>&1"

if crontab -l 2>/dev/null | grep -q "vault-sync.sh"; then
    echo "⚠️ Cron 任务已存在，跳过"
else
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✅ Cron 定时任务已添加（每5分钟同步）"
fi

echo ""
echo "=== 初始化完成 ==="
echo "vault 路径: $VAULT_DIR"
echo "同步日志: /tmp/vault-sync.log"
echo ""
echo "下一步："
echo "1. 在各 Agent 的对话中发送技能配置指令"
echo "2. 在 Windows/Mac 本机 clone 仓库并用 Obsidian 打开"
echo "3. 安装 obsidian-git 插件并配置自动同步"

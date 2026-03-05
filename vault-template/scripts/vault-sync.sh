#!/bin/bash
# vault-sync.sh — 服务器端 vault 自动同步脚本
# 部署位置：~/shared-vault/scripts/vault-sync.sh
# 用法：
#   ./vault-sync.sh push    # 提交并推送
#   ./vault-sync.sh pull    # 拉取远端更新
#   ./vault-sync.sh auto    # cron 定时用（pull + 如有本地变更则 push）

VAULT_DIR="$HOME/shared-vault"
LOG_FILE="/tmp/vault-sync.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

cd "$VAULT_DIR" || { log "ERROR: vault 目录不存在"; exit 1; }

case "$1" in
    push)
        git add -A
        if ! git diff --cached --quiet; then
            AGENT_NAME="${2:-unknown}"
            git commit -m "auto: $(date '+%Y-%m-%d %H:%M') via ${AGENT_NAME}"
            if git push origin main; then
                log "PUSH: 成功 (by ${AGENT_NAME})"
            else
                log "PUSH: 失败，尝试 rebase..."
                git pull --rebase origin main && git push origin main
                if [ $? -eq 0 ]; then
                    log "PUSH: rebase 后成功"
                else
                    git rebase --abort 2>/dev/null
                    log "PUSH: 冲突，需要手动处理"
                    exit 1
                fi
            fi
        else
            log "PUSH: 无变更，跳过"
        fi
        ;;
    pull)
        if git pull --rebase origin main; then
            log "PULL: 成功"
        else
            git rebase --abort 2>/dev/null
            git pull --no-rebase origin main
            log "PULL: rebase 冲突，改用 merge"
        fi
        ;;
    auto)
        # 先 pull
        git pull --rebase origin main 2>/dev/null || {
            git rebase --abort 2>/dev/null
            git pull --no-rebase origin main
        }
        # 再检查有没有本地变更需要 push
        git add -A
        if ! git diff --cached --quiet; then
            git commit -m "auto: $(date '+%Y-%m-%d %H:%M') sync"
            git push origin main 2>/dev/null
            log "AUTO: pull + push 完成"
        else
            log "AUTO: pull 完成，无本地变更"
        fi
        ;;
    *)
        echo "用法: $0 {push|pull|auto} [agent_name]"
        exit 1
        ;;
esac

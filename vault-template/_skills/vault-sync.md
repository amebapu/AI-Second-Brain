# Skill: vault-sync

## 说明
操作 vault 后自动进行 Git 同步（commit + push），以及定时从远端 pull。

## 触发时机
- 每次对 vault 执行写入/修改/删除操作后
- 每 5 分钟自动执行一次 pull（通过 cron 触发）

## 指令

### sync-push（写入后同步）
当你对 `~/shared-vault/` 下的文件进行了任何修改，请执行以下命令：

```bash
cd ~/shared-vault && git add -A && git diff --cached --quiet || git commit -m "auto: $(date '+%Y-%m-%d %H:%M') via {{agent_name}}" && git push origin main
```

要点：
1. `git diff --cached --quiet` 确保有变更才 commit，避免空提交
2. commit message 包含时间和 Agent 名称，方便追溯
3. 如果 push 失败（冲突），先执行 `git pull --rebase origin main` 再重试

### sync-pull（定时拉取）
定时执行：
```bash
cd ~/shared-vault && git pull --rebase origin main
```

如果 rebase 冲突：
1. 执行 `git rebase --abort`
2. 改用 `git pull --no-rebase origin main`（merge 策略）
3. 告知用户有冲突需要手动处理

### 冲突预防策略
- 各 Agent 尽量写入不同目录（减少冲突）
- 日志文件每天新建，不修改历史日志
- 同一文件在同一时刻只由一端修改

## 配置
在服务器上设置 cron 定时 pull：
```bash
# crontab -e
*/5 * * * * ~/shared-vault/scripts/vault-sync.sh auto >> /tmp/vault-sync.log 2>&1
```

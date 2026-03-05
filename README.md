<p align="center">
  <img src="assets/banner.png" alt="Second Brain Banner" width="600">
</p>

<h1 align="center">🧠 AI 第二大脑 — Multi-Agent × Obsidian × Git 三端同步系统</h1>

<p align="center">
  <strong>让 AI Agent 帮你记日志、收藏文章、整理知识，手机/电脑/服务器三端实时同步</strong>
</p>

<p align="center">
  <a href="#快速开始">快速开始</a> •
  <a href="#架构总览">架构总览</a> •
  <a href="#完整教程">完整教程</a> •
  <a href="#常见问题">FAQ</a>
</p>

---

## 这是什么？

一套**零代码**搭建的个人知识管理系统，核心特点：

- **🤖 多 AI Agent 协作** — 工作 Agent 做深度分析，个人 Agent 省 Token 记日常
- **📱 手机随时触发** — 对话 Agent 就能记日志、收藏文章、创建任务
- **💻 Obsidian 管理** — 所有笔记在 Obsidian 里查看、编辑、建立知识图谱
- **🔄 Git 自动同步** — Agent 写入 → GitHub → Obsidian 拉取，全自动

**你不需要会写代码**。只需要：一台云服务器 + 一个 GitHub 账号 + Obsidian 客户端 + AI Agent 平台账号。

---

## 架构总览

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  手机/电脑    │     │  手机/电脑    │     │  手机/电脑    │
│  对话 Agent   │     │  对话 Agent   │     │  对话 Agent   │
│  (公司A:深度) │     │  (公司B:任务) │     │  (个人:日常)  │
└──────┬───────┘     └──────┬───────┘     └──────┬───────┘
       │                    │                    │
       └────────────────────┼────────────────────┘
                            │ 读写文件
                            ▼
              ┌──────────────────────────┐
              │     云服务器              │
              │  ~/shared-vault/         │
              │  (Git 仓库 + 笔记文件)   │
              └────────────┬─────────────┘
                           │ git push / pull (每5分钟)
                           ▼
              ┌──────────────────────────┐
              │       GitHub 私有仓库     │
              │  (中转站，数据枢纽)       │
              └────────────┬─────────────┘
                           │ git push / pull (每5分钟)
                           ▼
              ┌──────────────────────────┐
              │    Windows / Mac 本机     │
              │    Obsidian + Git 插件    │
              │    (查看/编辑/知识图谱)    │
              └──────────────────────────┘
```

---

## Vault 目录结构

```
shared-vault/
├── _agents/                    # Agent 身份配置
│   ├── work-a/                 # 公司 Agent-A（深度分析）
│   │   ├── SOUL.md
│   │   ├── USER.md
│   │   └── MEMORY.md
│   ├── work-b/                 # 公司 Agent-B（任务管理）
│   │   └── ...
│   └── personal/               # 个人 Agent（日常省Token）
│       └── ...
├── _skills/                    # Agent 技能定义
│   ├── vault-sync.md           # Git 同步技能
│   ├── journal-manager.md      # 日志管理技能
│   ├── article-collector.md    # 文章收藏技能
│   └── knowledge-organizer.md  # 知识整理技能
├── _templates/                 # 笔记模板
│   ├── daily-journal.md
│   ├── article-capture.md
│   ├── task.md
│   └── knowledge-note.md
├── scripts/                    # 自动化脚本
│   ├── vault-sync.sh
│   └── setup-server.sh
├── 00_Inbox/                   # 收件箱
│   ├── articles/               # 待整理的文章
│   └── thoughts/               # 随手记的灵感
├── 01_Journal/                 # 日志（按日期命名）
├── 02_Knowledge/               # 知识库（分类整理后的笔记）
├── 03_Work/                    # 工作相关
│   ├── projects/
│   ├── meeting-notes/
│   └── internal-articles/
├── 04_Tasks/                   # 任务管理
│   ├── active/
│   └── done/
└── 05_Archive/                 # 归档（软删除目标）
```

---

## 快速开始

> **预估耗时**：约 60-90 分钟（完全零基础小白）

### 你需要准备

| 项目 | 说明 | 费用 |
|------|------|------|
| 云服务器 | 腾讯云/阿里云轻量应用服务器均可，Linux 系统 | ≈ ¥50/月起 |
| GitHub 账号 | 免费注册，用于代码托管 | 免费 |
| Obsidian | 笔记软件，[下载地址](https://obsidian.md) | 免费 |
| AI Agent 平台 | OpenClaw / Coze / 其他支持终端操作的 Agent 平台 | 视平台定价 |
| Git（Windows） | 版本控制工具，[下载地址](https://git-scm.com) | 免费 |
| Git（Mac） | macOS 自带，或通过 Xcode Command Line Tools 安装 | 免费 |

---

## 完整教程

### 阶段 1：本机配置 SSH Key

> SSH Key 是你电脑和 GitHub 之间的"钥匙"，有了它才能推送代码。
> 下面分 **Windows** 和 **Mac** 两套步骤，选你的系统操作即可。

#### Windows 用户

**1.1 检查是否已安装 Git**

打开 **PowerShell**（按 `Win+X`，选"终端"或"PowerShell"），输入：

```powershell
git --version
```

如果显示版本号（如 `git version 2.49.0`），说明已安装。如果报错，去 https://git-scm.com 下载安装。

**1.2 配置 Git 用户信息**

```powershell
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的邮箱"
```

**1.3 生成 SSH Key**

```powershell
ssh-keygen -t ed25519 -C "你的邮箱"
```

连按 3 次回车（使用默认路径，不设密码）。

**1.4 复制公钥**

```powershell
cat ~/.ssh/id_ed25519.pub
```

复制输出的**整行内容**（以 `ssh-ed25519` 开头）。

**1.5 添加到 GitHub**

1. 打开 https://github.com/settings/keys
2. 点 **New SSH Key**
3. Title 填 `Windows-PC`
4. Key 粘贴刚才复制的内容
5. 点 **Add SSH key**

**1.6 验证连接**

```powershell
ssh -T git@github.com
```

看到 `Hi xxx! You've successfully authenticated` 就成功了。

#### Mac 用户

**1.1 检查是否已安装 Git**

打开 **终端**（Terminal，可在"启动台"搜索"终端"或按 `Cmd+Space` 搜索 `Terminal`），输入：

```bash
git --version
```

如果弹出提示安装 Xcode Command Line Tools，点 **安装** 等待完成即可。如果显示版本号说明已安装。

**1.2 配置 Git 用户信息**

```bash
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的邮箱"
```

**1.3 生成 SSH Key**

```bash
ssh-keygen -t ed25519 -C "你的邮箱"
```

连按 3 次回车（使用默认路径，不设密码）。

**1.4 复制公钥到剪贴板**

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

> `pbcopy` 是 Mac 自带的命令，会直接复制到剪贴板，无需手动选择。

**1.5 添加到 GitHub**

1. 打开 https://github.com/settings/keys
2. 点 **New SSH Key**
3. Title 填 `Mac`
4. Key 直接 `Cmd+V` 粘贴
5. 点 **Add SSH key**

**1.6 验证连接**

```bash
ssh -T git@github.com
```

看到 `Hi xxx! You've successfully authenticated` 就成功了。

---

### 阶段 2：创建 GitHub 仓库并推送 Vault

**2.1 在 GitHub 创建私有仓库**

1. 打开 https://github.com/new
2. Repository name 填 `shared-vault`
3. 选 **Private**（私有）
4. **不要**勾选任何初始化选项
5. 点 **Create repository**

**2.2 克隆本项目的模板**

**Windows（PowerShell）：**

```powershell
cd ~

git clone https://github.com/amebapu/mycenter.git shared-vault-temp

Copy-Item -Recurse shared-vault-temp/vault-template/* shared-vault/
Copy-Item shared-vault-temp/vault-template/.gitignore shared-vault/

Remove-Item -Recurse -Force shared-vault-temp
```

**Mac（Terminal）：**

```bash
cd ~

git clone https://github.com/amebapu/mycenter.git shared-vault-temp

mkdir -p shared-vault
cp -R shared-vault-temp/vault-template/* shared-vault/
cp shared-vault-temp/vault-template/.gitignore shared-vault/

rm -rf shared-vault-temp
```

**2.3 初始化并推送**

**Windows / Mac 通用：**

```bash
cd ~/shared-vault
git init
git add -A
git commit -m "init: shared vault"
git branch -M main
git remote add origin git@github.com:你的GitHub用户名/shared-vault.git
git push -u origin main
```

---

### 阶段 3：云服务器配置

> 以腾讯云轻量应用服务器为例，其他云服务器类似。

**3.1 登录服务器**

通过云服务商的 **WebShell** 或本地 SSH 客户端登录。

**3.2 确认 Git 已安装**

```bash
git --version
```

大多数 Linux 发行版自带 Git。如果没有：
```bash
# Ubuntu/Debian
apt update && apt install -y git

# CentOS
yum install -y git
```

**3.3 生成服务器的 SSH Key**

```bash
ssh-keygen -t ed25519 -C "server"
```

连按 3 次回车。

**3.4 复制公钥并添加到 GitHub**

```bash
cat ~/.ssh/id_ed25519.pub
```

复制内容，去 GitHub → Settings → SSH Keys → **New SSH Key**，Title 填 `Cloud-Server`。

**3.5 ⚠️ 重要：配置 SSH（避免 Permission denied）**

> 很多云服务器有系统级 SSH 配置会覆盖默认 Key 路径，导致连接 GitHub 失败。提前配置可以避免这个坑。

```bash
cat > ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF

chmod 600 ~/.ssh/config
```

**3.6 验证连接**

```bash
ssh -T git@github.com
```

看到 `Hi xxx!` 就成功了。

**3.7 克隆仓库**

```bash
# 如果是 root 用户
cd /root
git clone git@github.com:你的GitHub用户名/shared-vault.git

# 如果是普通用户
cd ~
git clone git@github.com:你的GitHub用户名/shared-vault.git
```

**3.8 配置 Git 信息**

```bash
cd ~/shared-vault
git config user.name "server-agent"
git config user.email "server@agent.local"
git config pull.rebase true
```

**3.9 赋权同步脚本**

```bash
chmod +x ~/shared-vault/scripts/vault-sync.sh
```

**3.10 修正脚本路径（如果需要）**

如果你用的是 root 用户，脚本里的路径可能需要修改：

```bash
# 检查当前路径
grep -n "VAULT_DIR" ~/shared-vault/scripts/vault-sync.sh

# 如果显示 /home/user，需要改成你的实际路径
sed -i 's|/home/user/shared-vault|/root/shared-vault|g' ~/shared-vault/scripts/vault-sync.sh
sed -i 's|/home/user/shared-vault|/root/shared-vault|g' ~/shared-vault/scripts/setup-server.sh
```

**3.11 设置定时同步（crontab）**

```bash
# 编辑定时任务
crontab -e
```

在文件末尾添加（注意替换路径）：

```
*/5 * * * * /root/shared-vault/scripts/vault-sync.sh auto >> /tmp/vault-sync.log 2>&1
```

保存退出。验证：

```bash
crontab -l
```

---

### 阶段 4：Obsidian 配置

**4.1 打开 Vault**

1. 打开 Obsidian
2. 点「打开本地仓库」（Open folder as vault）
3. 选择 vault 文件夹：
   - **Windows**：`C:\Users\你的用户名\shared-vault`
   - **Mac**：`/Users/你的用户名/shared-vault`
4. 点「打开」

**4.2 安装 Git 插件**

1. 点左下角 ⚙️ 设置
2. 左侧菜单 → **第三方插件**
3. 关闭「安全模式」（首次需要确认）
4. 点「浏览」社区插件
5. 搜索 **Git**，找到作者是 **Vinzent03** 的 "Obsidian Git"
6. 点 **安装** → **启用**

**4.3 配置自动同步**

1. 设置 → 第三方插件 → **Git**
2. 找到以下设置项，修改为：

| 设置项 | 值 |
|--------|------|
| Auto commit-and-sync interval (minutes) | **5** |
| Auto push interval (minutes) | **5** |
| Auto pull interval (minutes) | **5** |

其他开关保持默认（关闭）即可。

**4.4 验证同步**

底部状态栏应显示类似 `Git: pull: everything is up-to-date`，表示插件正常工作。

---

### 阶段 5：配置 AI Agent

> 以 OpenClaw 为例。其他支持终端操作的 Agent 平台（Coze、Dify 等）原理类似。

核心目标：**让 Agent 知道 shared-vault 在哪，并学会操作它的技能**。

**5.1 在每个 Agent 的对话中发送以下内容**

#### 第一段：确认 vault 存在

```
请检查 ~/shared-vault/ 是否存在：
ls -la ~/shared-vault/
```

> 如果不存在，说明阶段 3 的 clone 没成功，需要回去重做。

#### 第二段：学习技能

```
请依次读取以下技能文件：

cat ~/shared-vault/_skills/vault-sync.md
cat ~/shared-vault/_skills/journal-manager.md
cat ~/shared-vault/_skills/article-collector.md
cat ~/shared-vault/_skills/knowledge-organizer.md

读完后，把以下内容追加到你的 AGENTS.md 文件末尾：

---

## 共享 Vault 技能

技能详情见 `~/shared-vault/_skills/` 目录：

### vault-sync
- 每次修改 vault 文件后，执行 git add + commit + push
- 命令：`cd ~/shared-vault && git add -A && git diff --cached --quiet || git commit -m "auto: $(date '+%Y-%m-%d %H:%M') via agent-name" && git push origin main`
- push 前先 pull：`cd ~/shared-vault && git pull --rebase origin main`

### journal-manager
- 管理 `~/shared-vault/01_Journal/` 下的日志

### article-collector
- 收藏文章到 `~/shared-vault/00_Inbox/articles/`

### knowledge-organizer
- 整理文章到 `~/shared-vault/02_Knowledge/`

## 关键规则
1. 共享 vault 路径：`~/shared-vault/`
2. 每次操作 vault 后必须执行 vault-sync
3. 删除只能软删除到 `05_Archive/`
4. 新建笔记必须使用 `~/shared-vault/_templates/` 下的模板
```

> ⚠️ 把 `agent-name` 替换为当前 Agent 的实际名称（如 `work-a`、`work-b`、`personal`）。

#### 第三段：更新用户信息

```
请在你的 USER.md 中追加以下信息：

## Obsidian Vault
- 共享 vault 路径：~/shared-vault/
- GitHub 仓库：git@github.com:你的用户名/shared-vault.git
- 同步方式：Git 自动同步（服务器 cron 每5分钟，Obsidian Git 插件每5分钟）
```

**5.2 每个 Agent 都重复以上 3 段**

对你的每一个 Agent（公司A、公司B、个人）都发送上面的指令。

---

### 阶段 6：端到端测试

配完后，做以下验证：

| # | 操作 | 在哪做 | 预期结果 |
|---|------|--------|---------|
| 1 | 对 Agent 说"帮我记日志：测试同步" | 手机 Agent 对话 | Agent 在 01_Journal/ 创建文件并 git push |
| 2 | 等 5 分钟，检查 Obsidian | 电脑 Obsidian | 自动拉取，看到新日志文件 |
| 3 | 在 Obsidian 编辑日志，加一行内容 | 电脑 Obsidian | 5 分钟内自动 commit + push |
| 4 | 对 Agent 说"看看今天的日志" | 手机 Agent 对话 | Agent 能看到你在 Obsidian 编辑的内容 |
| 5 | 对 Agent 说"收藏这篇文章 https://..." | 手机 Agent 对话 | 在 00_Inbox/articles/ 生成笔记 |

全部通过 = 🎉 **系统搭建完成！**

---

## 多 Agent 分工策略

| Agent | 模型建议 | 职责 | 主要操作目录 |
|-------|---------|------|-------------|
| 公司 A | Claude / GPT-4（强推理） | 深度文章分析、知识整理、知识图谱 | 02_Knowledge/, 03_Work/ |
| 公司 B | Claude / GPT-4 | 任务管理、会议纪要、工作流 | 03_Work/, 04_Tasks/ |
| 个人 | Kimi / 较便宜模型 | 日常日志、简单收藏、快速问答 | 00_Inbox/, 01_Journal/ |

**省 Token 策略**：日常高频操作（记日志、简单收藏）用便宜的个人 Agent，深度分析和批量整理交给公司 Agent。

---

## 自定义指南

### 添加新 Agent

1. 在 `_agents/` 下创建新目录，写 SOUL.md、USER.md、MEMORY.md
2. 在 Agent 平台创建新 Agent
3. 让新 Agent 读取 `_skills/` 下的技能文件

### 添加新技能

1. 在 `_skills/` 下创建新的 `.md` 文件
2. 定义触发词、执行步骤、vault-sync 规则
3. 让各 Agent 读取新技能

### 修改目录结构

根据你的需求调整 vault 目录。建议保持：
- `00-05` 编号前缀（Obsidian 侧边栏排序友好）
- `_` 开头的目录用于配置（不会干扰正常笔记）

---

## 常见问题

### Q: 服务器上 `ssh -T git@github.com` 报 Permission denied？

大概率是服务器的系统级 SSH 配置覆盖了你的 Key。解决方法：

```bash
cat > ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF
chmod 600 ~/.ssh/config
```

### Q: Obsidian 没有自动同步？

检查 3 个设置是否都填了 `5`：
- Auto commit-and-sync interval → 5
- Auto push interval → 5
- Auto pull interval → 5

### Q: Agent 说找不到 vault 目录？

1. 确认服务器上 `~/shared-vault/` 存在
2. Agent 平台的终端可能用不同用户，执行 `whoami` 和 `echo $HOME` 确认路径

### Q: Git 冲突了怎么办？

同步脚本已内置冲突处理：先尝试 rebase，失败则 merge。极少数情况需要手动处理，在服务器执行：

```bash
cd ~/shared-vault
git status              # 查看冲突文件
git checkout --theirs . # 保留远端版本（或 --ours 保留本地）
git add -A && git commit -m "resolve conflict"
git push origin main
```

### Q: 可以用其他 Agent 平台吗？

可以。核心需求是 Agent 能**执行终端命令**（读写文件 + 执行 git）。满足这个条件的平台都能用，如 Coze、Dify、自建 Agent 等。

### Q: 可以用其他笔记软件替代 Obsidian 吗？

理论上任何支持打开本地文件夹的 Markdown 编辑器都可以。但 Obsidian 的优势在于：
- 双向链接和知识图谱
- Obsidian Git 插件实现零配置同步
- 丰富的社区插件生态

---

## 贡献

欢迎提 Issue 和 PR！如果你有新的 Agent 技能或目录结构改进方案，非常欢迎分享。

1. Fork 本仓库
2. 创建分支 `git checkout -b feature/你的改进`
3. 提交 PR

---

## 致谢

本项目灵感来自对「AI 是否能成为真正的第二大脑」的探索。感谢：
- [Obsidian](https://obsidian.md) — 强大的本地知识管理工具
- [Obsidian Git](https://github.com/denolehov/obsidian-git) — 让 Obsidian 具备 Git 同步能力
- [OpenClaw](https://openclaw.com) — AI Agent 平台

---

## 觉得有用？

如果这个项目对你有帮助，请点个 ⭐ Star 支持一下！也欢迎分享给朋友。

---

## License

[MIT License](LICENSE) — 随意使用、修改、分享。

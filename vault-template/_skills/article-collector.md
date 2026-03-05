# Skill: article-collector

## 说明
抓取网页文章 → 提取正文 → 生成摘要 → 打标签 → 存入 Obsidian vault 的收藏夹。

## Vault 路径
`~/shared-vault/`

## 指令

### 收藏文章
当用户发送一个 URL 并说"收藏"、"存一下"、"保存这篇"等：

1. **判断链接类型**：
   - 公司内网链接 → 只有公司 Agent 能访问
   - 外网链接 → 所有 Agent 都能处理
   - 如果个人 Agent 收到内网链接 → 回复"这是内网链接，建议转发给公司 Agent 处理"

2. **抓取内容**：
   使用 web_search 或 fetch 工具获取网页内容

3. **提取与整理**：
   - 标题
   - 正文（去掉导航、广告、侧边栏等无关内容）
   - 生成 3-5 句摘要
   - 提取 3-5 个关键要点
   - 自动打标签（根据内容主题）

4. **生成笔记文件**：
   文件名：`00_Inbox/articles/YYYY-MM-DD-文章标题简写.md`
   
   使用模板格式：
   ```yaml
   ---
   date: "YYYY-MM-DD"
   type: article
   source: "原始URL"
   title: "文章标题"
   tags: [标签1, 标签2]
   status: unread
   created_by: "当前agent名"
   ---
   
   # 文章标题
   
   > 来源：[原文链接](URL)
   > 采集时间：YYYY-MM-DD HH:MM
   
   ## 摘要
   3-5 句话概括
   
   ## 关键要点
   - 要点1
   - 要点2
   - 要点3
   
   ## 正文
   整理后的文章正文
   
   ## 我的笔记
   （留空，供用户后续添加）
   ```

5. **特殊处理**：
   - 公司内网文章存入：`03_Work/internal-articles/`
   - 外网文章存入：`00_Inbox/articles/`

6. **vault-sync**

### 查看收藏
当用户说"看看收藏"、"最近收藏了什么"等：

1. 列出 `00_Inbox/articles/` 和 `03_Work/internal-articles/` 中的文件
2. 按日期倒序展示（最新在前）
3. 标注状态：unread / read / processed

### 批量整理收藏
当用户说"整理收藏"、"把收藏的文章归类"等：

⚠️ 此操作较重，个人 Agent 应建议用户转发给公司 Agent。

1. 扫描 `00_Inbox/articles/` 中 status=unread 的文件
2. 按主题分类
3. 提取共性知识
4. 告知用户分类结果，确认后执行移动/整合

## 省 Token 策略（个人 Agent 专用）
- 摘要限制在 3 句以内
- 关键要点最多 3 个
- 正文做精简处理，不完整保留原文
- 如果文章超过 3000 字，建议转发给公司 Agent

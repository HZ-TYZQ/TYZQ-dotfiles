# TYZQ 的 dotfiles 配置

默认分支 `cachyos` 管理从 Fedora 迁移后、已在 CachyOS 上恢复并使用的配置。
`fedora` 由原 `master` 重命名而来，保留现有历史，包括已合并的 CachyOS 配置。
旧 Fedora 配置可在迁移前的 Git 历史中查看。
唯一维护源目录：`~/.local/share/chezmoi`。

## 仓库结构

`.chezmoiroot` 把 chezmoi 的源状态指向 `home/`：其中的文件对应家目录，
`.chezmoi.toml.tmpl` 和 `.chezmoiignore` 也在这里。仓库根目录的 README、`docs/`、
`scripts/` 和 Git 配置只属于仓库本身，不会部署到家目录。

## 已纳入 Git 管理

- Niri：窗口、快捷键、输入、会话和显示器模板；屏幕标识、模式和缩放由本机 chezmoi 数据提供，不写入共享模板。
- Noctalia：`~/.config/noctalia/config.toml` 中的基础配置。
- 会话环境变量：`environment.d` 统一设置编辑器、Qt6ct、npm 和 Claude Code 的变量；Fish、Zsh 在 TTY/SSH 登录时导入同一份。
- Claude Code：用户偏好和状态栏脚本。
- Fcitx5：输入法、快捷键、拼音偏好及通知等配置。
- Fish、Starship、Fastfetch：终端初始化、提示符、欢迎语和字符画。
- Kitty、Alacritty：字体、配色与默认终端选择。
- Qt6ct：Fusion 风格、Noto 字体、Papirus-Dark 图标及启动环境；配色由 Noctalia 生成，路径随家目录渲染。
- 桌面应用图标：GTK 3/4、Qt6ct 的 Papirus-Dark 设置，以及 Niri 登录时的图标主题设置。
- mpv：Mochi 控制栏、快捷键、字幕、播放偏好和自动省电脚本。
- Zsh、Vim：启动配置及缓存、状态文件的位置设置。
- Neovim：LazyVim 配置、插件锁定文件、Markdown 配置及 Taplo 兼容设置。
- Git：gh 凭据助手设置模板；提交身份由本机 chezmoi 数据提供。
- npm：安装前缀、镜像源和缓存位置。
- `qq-show`：通过托盘唤起已运行的 Flatpak QQ。
- 英文 XDG 用户目录设置。

没有安装脚本或自动提交、推送、应用钩子。

## 仅在本机管理，不纳入 Git

以下内容仍由本机 chezmoi 管理，但不会随提交、推送上传：

| 内容 | 位置 | 原因 |
| --- | --- | --- |
| Git 提交身份 | `~/.config/chezmoi/chezmoi.toml` 的 `gitName`、`gitEmail` | 每台机器单独设置 |
| Noctalia GUI 设置：面板、组件、主题、壁纸路径、闲置行为等 | `home/private_dot_local/state/noctalia/settings.toml.tmpl` | 含个人壁纸和头像文件名 |
| Fcitx5 的 `bed-money` / `OriDark` 主题文件 | `home/private_dot_local/private_share/private_fcitx5/themes/` | 第三方作品，素材限制再分发 |

后两项的源副本由 `.gitignore` 按具体路径排除，需要单独备份；在新机器克隆仓库或执行
`chezmoi init` 无法恢复它们，配置中引用的 Fcitx5 主题也需要另行恢复。

Claude Code 的用户目录已迁到 `~/.config/claude`。其中只有 `settings.json` 和
`statusline-command.sh` 纳入 chezmoi 和 Git；`.claude.json`、`.credentials.json`、
会话历史、项目状态、插件和同步技能等数据只留在本机，不复制到 chezmoi 源目录。
修改公开的 `settings.json` 时不要写入密钥、Token 或账号信息。

软件、字体、壁纸和插件运行数据需要另行安装或恢复。
浏览器登录、密钥、keyring、gh 凭证、输入法用户词库、历史和缓存不纳入本仓库。
Noctalia 生成的颜色文件不纳管；天气位置保留在本机，不写进 Git。

## 日常保存

在家目录或应用界面修改配置后：

```sh
chezmoi re-add
python3 ~/.local/share/chezmoi/scripts/capture-noctalia.py
chezmoi diff
chezmoi git status --short
chezmoi git diff
```

`re-add` 更新已管理的普通文件；新文件需要单独 `chezmoi add 路径`。
Noctalia 的 GUI 设置用上面的脚本保存，它会移除天气位置数值并模板化家目录路径。
该脚本更新的是 Git 忽略的本机模板；GUI 设置的变化不会出现在 `git diff` 中。
Niri 的入口和 `hosts/laptop.kdl` 都是模板，通用结构用 `chezmoi edit` 修改；其余 Niri 片段可正常 `re-add`。
本机屏幕标识、模式和缩放以及 Git 身份在 `~/.config/chezmoi/chezmoi.toml` 的 `[data]` 中维护，详见使用指南。
Qt6ct 和 Git 配置也使用模板，用 `chezmoi edit ~/.config/qt6ct/qt6ct.conf`、
`chezmoi edit ~/.config/git/config` 修改；普通 `re-add` 会跳过模板。

确认 Git 差异后，按具体路径 `git add`，再提交和推送。不要直接添加整个家目录或 `.config`。
更多部署、依赖与维护说明见 [使用指南](docs/使用指南.md)。

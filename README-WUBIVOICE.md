# WubiVoice 五笔输入法

WubiVoice 是面向 macOS 26 的 86 版五笔输入法，直接 fork 自
[rime/squirrel](https://github.com/rime/squirrel)，并内置极点风格五笔方案。

## 固定版本

- Squirrel `1.1.2`：`876adebaf2f612951dcdca8a591de65401222b9a`
- rime-wubi86-jidian：
  `a194fb8b3ec41ef9dcf079d3a67876fa75f79135`
- librime-lua：`ec52e48ea18f11af37717a01c337f853215cf70b`

当前开发 fork 是
[`ioldwang/WubiVoice-IME`](https://github.com/ioldwang/WubiVoice-IME)。
公开发布前必须转移到 `genli-ai/WubiVoice-IME`，并保持提交历史不变。

## 构建

需要完整 Xcode 26、CMake 4 以及已初始化的 Git submodule。

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  ./action-install.sh
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  make release ARCHS='arm64 x86_64' \
  MACOSX_DEPLOYMENT_TARGET=26.0
bash scripts/verify-release
```

输出位于：

```text
build/Build/Products/Release/WubiVoice.app
```

开发安装命令为：

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  make install-release ARCHS='arm64 x86_64' \
  MACOSX_DEPLOYMENT_TARGET=26.0
```

正式用户不需要运行命令；主项目会把此应用封装进图形化 `.pkg`。

## 默认行为

- 输入方案默认是 `WubiVoice 极点五笔 86`。
- Enter 默认提交尚未完成的英文编码。
- 输入法菜单中的 `Enter 清除编码` 可改为按 Enter 清除组合。
- `-` 和 `=` 翻页，左 Shift 提交编码，右 Shift 不处理。
- 用户配置与词频只写入 `~/Library/WubiVoice/Rime`，不会读写
  `~/Library/Rime`，可以与原版 Squirrel 共存。

## 许可证

本 fork 依 GPL-3.0 发布。分发二进制时必须同时提供精确对应提交的完整源码、
构建和安装脚本以及 GPL 文本。librime、librime-lua、Sparkle、OpenCC 和五笔
方案保留各自许可证；详见 `THIRD_PARTY/LICENSES.md` 和
`THIRD_PARTY/WUBI_SCHEMA.md`。

极点风格五笔方案来自 Apache-2.0 项目，并保留原许可证、来源和 WubiVoice 修改
记录。Developer ID 签名与公证不得限制用户自行修改、构建和分发 GPL 组件。

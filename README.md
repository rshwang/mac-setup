# Mac-setup 🍇

![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)  [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 简介 🙉

该项目为重装后的Mac的OS X系统自动安装所需软件，免去了重装系统后一个个安装的琐碎工作。所有软件主要基于Homebrew来安装命令行工具和图形界面软件。用户可根据自己的需求配置两个不同的文件中所包含的软件列表，便于重装系统后一次性安装系统所需软件。

1. 根据个人使用情况分别设置命令行工具和图形界面软件清单

2. 默认全部安装，可设置选择性安装。

## 要求

基于macOS Mojave Version 10.14.6和Homebrew版本 2.1.4开发，不能保证过早的版本正常运行。

## 缘起 🙈

Homebrew是Mac系统中较好的软件管理系统，特别可以分别针对命令行工具和图形界面软件都能找到所需软件。而操作系统无论是长时间使用或意外中毒等原因，可能需要重装系统。而Mac系统的优势就是可以通过shell脚本直接安装所需的大部分软件，避免逐一下载安装软件所需要的大量时间和精力。因此通过github上的现有脚本进行改进，根据自己电脑配置需求设计该项目。便于重装系统后自动化的软件安装。

## 注意事项

* 安装卡顿问题

如遇较大软件包或网速卡顿，安装时间消耗较长时可以直接Ctrl+C，打断当前软件包的安装，并重新运行

* 源的问题

由于国内直接访问Homebrew的官方源很慢（龟速那种慢），所以本脚本将源换成了中国科学技术大学USTC的源，homebrew-core, homebrew-cask以及源代码仓库全都换了。

## 使用 🙊

打开您喜欢的终端模拟器，简单执行下面两条命令即可

```bash
git clone https://github.com/rshwang/mac-setup.git && cd mac-setup
chmod u+x install.sh &&./install.sh
```

安装软件包的时间，和您的网络情况有关，也和安装目标有关，比如安装包较大，就需要多花一点时间，请耐心等待。

## 软件清单 🐕

软件清单分两个，`cli.txt gui.txt`，cli.txt中，包含了可以使用`brew install`来安装的一些命令行软件工具，如果并非专业技术人员，所需安装的软件可能很少。gui.txt中，包含了使用`brew cask install`来安装的图形化界面工具，比如QQ，微信，腾讯视频等。

![app_list](pic/app-list.jpg)

```text
#  命令行软件工具清单 cli.txt
None

#  图形化软件工具清单 gui.txt
1. qq 腾讯QQ
2. mactex-no-gui Latex基础工具
3. lantern 外网访问软件Lantern
4. qqlive 网易云音乐
5. visual-studio-code 微软脚本编辑工具
6. zotero 文献管理软件
7. wechat 微信
8. miniconda 开发环境管理软件
9. sogouinput 搜狗拼音输入法
10. baidunetdisk 百度网盘

```

## 添加自定义的软件清单

直接修改或添加cli.txt以及gui.txt文件即可。注意清单文本中按如下规则：`1 package-name 软件包介绍`。注意：每行一个软件包，编号、包名和介绍间用一个空格分隔。

## star与fork以及项目维护

该项目fork自[jsycdut/mac-setup](https://github.com/jsycdut/mac-setup)，根据个人需要对项目进行适当修改，大家可以点击链接查看原始脚本内容，也可以根据自己的需求进行个性化修改。我会根据我的实际需求加入一些个性化的电脑配置脚本，保证重装系统后一键配置完成。因此在使用前尽可能了解其是否适合于自己。

## 使用效果 🐈

在我的12寸的MacBook，OS X 10.14.6的安装效果如下，因为暂时没有需要的命令行软件，所以跳过该部分安装。

![install-gui](pic/app-install.jpg)
![install-cli](pic/mac-config.jpg)

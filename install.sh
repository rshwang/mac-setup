#! /bin/bash

cat << -EOF
#######################################################################
# 当前脚本用于在重装OS X系统的电脑上自动安装应用程序
#       本程序利用homebrew作为OS X的包管理器
#       brew install 安装命令行程序
#       brew cask install 安装GUI程序
#
# Author: R. Wang <rshwang@sina.cn>
# Github: https://github.com/rshwang/mac-setup
#
# Forked from: https://github.com/jsycdut/mac-setup
#
# 祝使用愉快。
#
#============================Version 1.1===============================
# 更新内容：
# 1. 修复新装MAC没有安装git无法使用软件的问题。
# 2. 改变软件下载及安装方式。
# 3. 补充需要安装的图形界面和命令行软件。
#
#######################################################################
-EOF

# 检测文件完整性
echo '检测文件完整性，请稍候...'
shasum -c checksum.sha1 > /dev/null

if [[ $? -eq 0 ]]; then
  echo '文件效验效验成功，即将开始系统安装及配置！'
else
  echo '文件效验不通过，请检查文件完整性或重新下载安装文件！'
  exit 128
fi

# 全局变量
row_number=0
column_number=0
lo=0
# 获取安装清单文件中的软件所在行列
type=cli
# 用于定位文件是用户界面还是命令行软件
WD=`pwd`

# 安装Homebrew并换TUNA源
install_homebrew() {
  if `command -v brew &> /dev/null`; then
    echo '👌  Homebrew已安装'
  else
    echo '🍼  开始安装Homebrew'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    if [[ $? -eq 0  ]]; then
      echo '🍻  Homebrew安装成功'
    else
      echo '🚫  Homebrew安装失败，请检查网络连接...'
      exit 127
    fi
  fi

  echo '👍  为了让brew运行更加顺畅，将切换为清华大学TUNA提供的镜像，请稍后...'
  
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  echo 'origin 仓库切换成功'
  
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  echo 'Homebrew/core 远程仓库切换成功'

  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  echo 'Homebrew/cask 远程仓库切换成功'

  echo '远程仓库切换完成！'
  echo '正在检查Homebrew是否为最新版...'
  brew update
}

# 检查软件包安装，传入软件包名称参数
check_installation() {
  if [[ $type == "cli" ]]; then
    brew list -l | grep $1 > /dev/null
  else
    brew cask list -1 | grep $1 > /dev/null
  fi
  # 通过list命令查看软件是否存在，如果存在返回值为0，否则返回1。

  if [[ $? -eq 0 ]]; then
     return 0
  fi

  return 1
}

# 使用brew命令安装软件包，传入软件包名称参数
install() {
  check_installation $1
  # 安装前先检查是否已安装
  if [[ $? -eq 0 ]]; then
    echo "👌 ==>已安装" $1 "，跳过..."
  else
    echo "🔥 ==>正在安装 " $1
    if [[ "$type" == "cli" ]]; then
      brew install $1 > /dev/null
      echo $?
    else
      brew cask install $1
    fi

    if [[ $? -eq 0 ]]; then
      echo "🍺 ==>安装成功 " $1
    else
      echo "🚫 ==>安装失败，请重试！ " $1
      echo $1 >> "$type"".fail"
    fi
  fi
}

# 根据用户输入内容显示安装软件列表，传入安装文件编号参数。
# [0]:命令行软件列表文件；[1]:图形界面软件列表文件。
show_menu() {
  case $1 in
    0) echo "输出命令行软件列表："
       cd $WD && cat cli.txt | awk '{print $1 ". " $2 "\t" $3}' && type="cli"   
    ;;
    1) echo "输出图形化软件列表："
       cd $WD && cat gui.txt | awk '{print $1 ". " $2 "\t" $3}' && type="gui"
    ;;
  esac
  echo
}

# 利用awk，从cli.txt gui.txt两文件中截取软件包名称。
# 不要破坏cli.txt gui.txt文件排版。
# 否则会导致软件包名称提取失败。
# 分别传入软件包列表文件名称和所需软件所在行号。
get_package_name() {
  local file_name=$1
  local row=$2
  cat $file_name | grep -w $row | awk '{print $2}'
}

# 程序入口
echo
echo "🙏  请花5秒时间看一下上述注意事项"
sleep 5s
install_homebrew
while [[ $lo -lt 2 ]]; do
  show_menu $lo
  if [ ! -s "$type"".txt" ]; then
    lo=`expr $lo + 1`
    echo "该软件列表中没有内容，跳过安装！"
    continue
  fi
    
  read  -p "✍️ 请输入想要安装的软件包编号（多个请用空格分隔，回车安装全部：）" ans
  echo
  IFS=$'\n'
  read -d "" -ra arr <<< "${ans//' '/$'\n'}" # 本脚本中最喜欢的一句代码了

  # 如用户输入回车，将数组赋值为文件中的全部软件包编号
  if [[ "${#arr[@]}" -eq 0 ]]; then
    lines=`wc -l "$type"".txt" | awk '{printf $1}'`
    for((i=0; i<$lines; i++)); do
      arr[$i]=`expr $i + 1`
    done
  fi

  for app in ${arr[*]}; do
    if [ $app -eq $app 2>/dev/null ]; then
      :
    else
      continue
    fi

    name=`get_package_name "$type"".txt" $app`
    [ -z "$name" ] && continue
    install $name
  done

  lo=`expr $lo + 1`
done
if [ -s gui.fail -o -s cli.fail ]; then
  for stwr in `ls *.fail`; do
    if [ -n $stwr ]; then
      echo "❗️ 以下软件未成功安装，请检查并重新安装："
      cat $stwr
    fi
  done
fi

rm -rf *.fail

echo " ⁉️  下面将进行电脑个性化设置，请稍后。⁉️"
cd

# 安装oh-my-zsh后命令提示符会更改登录提示符，因此此过程省略。
# 替换用户登录提示符...
# echo "正在调整命令提示符，请输入用户密码..."
# sudo sed -i "" -e '/^PS1/{s//# PS1/; a\
# PS1="\\u: \\W\\$ "
# }' /etc/bashrc && echo "命令提示符替换成功！" && source /etc/bashrc

# 生成用户RSA秘钥，会提示输入密码，可直接回车跳过设置密码。

echo "正在生成本地SSH Key..."
ssh-keygen -t rsa -b 4096 -C "rshwang@sina.cn"

echo "安装oh-my-zsh..."
git clone https://github.com/robbyrussell/oh-my-zsh
if [[ $? -eq 0 ]]; then
  echo 'oh-my-zsh下载成功，将执行安装程序！'
  cd oh-my-zsh/tools
  sh install.sh
else
  echo 'oh-my-zsh下载失败，请检查网络，重新手动下载安装！'
fi

echo "💗感谢您使用Mac自动配置程序，再见！💖"
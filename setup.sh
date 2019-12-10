#!/bin/sh

# ================================================================================
#   Setup MacOs
# ================================================================================

if [ "$(uname)" != "Darwin" ] ; then
  echo 'Hmmm, its Not MacOS!'
  exit 1
fi

echo 'Setup MacOS!'

# Command Line Tools for Xcode
xcode-select --install

# HomeBrew
if [ ! -x "`which brew`" ] ; then
  echo "start install and update brew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
  brew upgrade
  brew -v
fi


# Macbook本体のセッティング
chflags nohidden ~/Library    # ~/Library ディレクトリを可視化
sudo chflags nohidden /Volumes    # /Volumes ディレクトリを可視化
sudo nvram SystemAudioVolume=" "    # ブート時のサウンド無効化

echo 'Congrats!! Yout are all set!'


# 参考記事
# http://neos21.hatenablog.com/entry/2019/01/10/080000 (defaultsコマンド)
# https://qiita.com/kai_kou/items/af5d0c81facc1317d836 (setup.shまとめ)
# https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd (環境構築系記事)
# https://qiita.com/hkusu/items/18cbe582abb9d3172019 (Gistについて)

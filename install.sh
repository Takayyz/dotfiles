#!/bin/bash

# -----------------------------------------------------
#  dotfileのsymlinkをホームディレクトリに貼るスクリプト
#  .gitは処理をスキップ
# -----------------------------------------------------
for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$f" "$HOME"/"$f"
done

#ln -sf ~/dotfiles/.zlogin ~/.zlogin
#ln -sf ~/dotfiles/.zlogout ~/.zlogout
#ln -sf ~/dotfiles/.preztorc ~/.zprestorc
#ln -sf ~/dotfiles/.zprofile ~/.zprofile
#ln -sf ~/dotfiles/.zshenv ~/.zshenv
#ln -sf ~/dotfiles/.zshrc ~/.zshrc
#ln -sf ~/dotfiles/.vimrc ~/.vimrc
#ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

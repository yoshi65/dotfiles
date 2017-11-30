#!/bin/zsh

dot_path=`mdfind dotfiles | grep /dotfiles$`
cd $dot_path

echo "checking .zsh*"

echo ".zshrc"
diff -u ./.zshrc ~/.zshrc > diff_zshrc
if [ ! -s ./diff_zshrc ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.zshrc < diff_zshrc
fi

echo ".zshenv"
diff -u ./.zshenv ~/.zshenv > diff_zshenv
if [ ! -s ./diff_zshenv ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.zshenv < diff_zshenv
fi
echo ""


echo "checking .vimrc"
diff -u ./.vimrc ~/.vimrc > diff_vimrc
if [ ! -s ./diff_vimrc ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.vimrc < diff_vimrc
fi
echo ""


echo "checking .config"

echo "init.vim"
diff -u ./.config/nvim/init.vim ~/.config/nvim/init.vim > diff_init
if [ ! -s ./diff_init ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.config/nvim/init.vim < diff_init
fi

echo "dein.toml"
diff -u ./.config/dein/dein.toml ~/.config/dein/dein.toml > diff_dein
if [ ! -s ./diff_dein ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.config/dein/dein.toml < diff_dein
fi

echo "dein_lazy.toml"
diff -u ./.config/dein/dein_lazy.toml ~/.config/dein/dein_lazy.toml > diff_dein_lazy
if [ ! -s ./diff_dein_lazy ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.config/dein/dein_lazy.toml < diff_dein_lazy
fi

echo "clang.toml"
diff -u ./.config/dein/clang.toml ~/.config/dein/clang.toml > diff_clang
if [ ! -s ./diff_clang ]; then
  echo -e "\033[0;32mno diff\033[0;39m"
else
  echo -e "\033[0;31mdiff\033[0;39m"
  patch -u ./.config/dein/clang.toml < diff_clang
fi


rm -f diff_*

#!/bin/zsh


echo "checking .vimrc"
diff -u ./.vimrc ~/.vimrc > diff_vimrc
if [ ! -s ./diff_vimrc ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.vimrc < diff_vimrc
fi
echo "completed!\n"


echo "checking .config"

echo "init.vim"
diff -u ./.config/nvim/init.vim ~/.config/nvim/init.vim > diff_init
if [ ! -s ./diff_init ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.config/nvim/init.vim < diff_init
fi

echo "dein.toml"
diff -u ./.config/dein/dein.toml ~/.config/dein/dein.toml > diff_dein
if [ ! -s ./diff_dein ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.config/dein/dein.toml < diff_dein
fi

echo "dein_lazy.toml"
diff -u ./.config/dein/dein_lazy.toml ~/.config/dein/dein_lazy.toml > diff_dein_lazy
if [ ! -s ./diff_dein_lazy ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.config/dein/dein_lazy.toml < diff_dein_lazy
fi

echo "clang.toml"
diff -u ./.config/dein/clang.toml ~/.config/dein/clang.toml > diff_clang
if [ ! -s ./diff_clang ]; then
  echo "no diff"
else
  echo "diff"
  patch -u ./.config/dein/clang.toml < diff_clang
fi

echo "completed!"


rm -f diff_*

#!/bin/bash

set -xe
declare -A settings
## all global settings
src_dir=$(cd $(dirname ${BASH_SOURCE[*]}) && pwd)
settings=(
    ["PREFIX"]="$src_dir"
    [custom]="cus tom"
    [hi]="hello !"
)

for pname in "${!settings[@]}"
do
    pval=${!pname}
    if [$pval eq ""]
    then
	pval="settings[$pname]"
	pval="${!pval}"
	declare ${pname}="${pval}"
    fi
done

## Print all settings
for pname in "${!settings[@]}"
do
    echo "${pname} = ${!pname}"
done

## zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $PREFIX/oh-my-zsh
git clone https://github.com/bhilburn/powerlevel9k.git $PREFIX/oh-my-zsh/custom/themes/powerlevel9k
git clone https://github.com/zsh-users/zsh-history-substring-search $PREFIX/oh-my-zsh/custom/themes/zsh-history-substring-search
ln -s $PREFIX/ycwzsh/zshrc $HOME/.zshrc || \
    (mv $HOME/.zshrc $HOME/.zshrc_ycwkack && \
    ln -s $PREFIX/ycwzsh/zshrc $HOME/.zshrc)
sed -i "s!^local\\sYCW_CONF=.*\$!local YCW_CONF=\"$PREFIX\"!g" $PREFIX/ycwzsh/zshrc

## git
git config --global user.name "YcWang"
git config --global user.email "ycw.puzzle@hotmail.com"
git config --global core.autocrlf input
git config --global hub.protocol https

sudo "$PREFIX/install-packages.sh"

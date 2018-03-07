#!/bin/bash

ycwinstall(){
    pacman -S $* --noconfirm --needed
}

ycwinstall awesome-terminal-fonts

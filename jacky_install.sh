#!/bin/bash
# coding: utf-8

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

echo "请选择脚本安装语言/Please select script installation language"
echo "1. zh-CN 简体中文"
echo "2. en-US 英语(美国)"
echo -n "Enter your choice (1/2): "

read choice

case $choice in
    1)
        curl -LO https://raw.githubusercontent.com/ChijansLewis/Linuxscripts/main/jacky_zh.sh 
        chmod +x jacky_zh.sh
        echo "第一次执行请使用 ${GREEN}./jacky_zh.sh && . ~/.bashrc${RESET} 命令，以后可以用${GERRN}jacky${RESET}调用脚本"
        ;;
    2)
        curl -LO https://raw.githubusercontent.com/ChijansLewis/Linuxscripts/main/jacky_en.sh 
        chmod +x jacky_en.sh
        echo "Please use the ${GREEN}./jacky_en.sh && . ~/.bashrc${RESET} command for the first execution. You can use ${GERRN}jacky${RESET} to call the script in the future."
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

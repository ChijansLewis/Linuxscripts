#!/bin/bash
# coding: utf-8

# 检查是否已设置别名
if ! grep -q "alias jacky=" ~/.bashrc; then
    # 获取当前脚本的完整路径
    script_path="$(realpath $0)"
    
    # 将别名添加到.bashrc
    echo "alias jacky='$script_path'" >> ~/.bashrc
    source ~/.bashrc
fi


# 颜色的ANSI转义序列
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

# 获取当前用户名
current_user=$(whoami)

# 检查sudo权限
if sudo -l > /dev/null 2>&1; then
    sudo_status="${GREEN}yes${RESET}"
else
    sudo_status="${RED}no${RESET}"
fi

# 防火墙状态
ufw_status=$(sudo ufw status | grep "Status")
if [[ $ufw_status == "Status: inactive" ]]; then
    ufw_status="${RED}inactive${RESET}"
else
    ufw_status="${GREEN}active${RESET}"
fi

# 拥塞控制算法
congestion_algo=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')

# 用户信息
echo -e "${BLUE}当前用户：${RESET} $current_user"
echo -e "${BLUE}Sudo权限：${RESET} $sudo_status"
echo -e "${BLUE}防火墙状态：${RESET} $ufw_status"
echo -e "${BLUE}拥塞控制算法：${RESET} $congestion_algo"
echo -e "${BLUE}使用命令运行脚本：${RESET} jacky 或 $0"
echo "----------------------------------------"

# Main Menu
echo "主菜单："
echo "1. 执行apt更新"
echo "2. 检查系统配置"
echo "3. 安装BBR2"
echo "4. 安装x-ui (FranzKafkaYu)"
echo "5. 安装x-ui (sing-web)"
echo "6. 禁用防火墙 (UFW)"
echo "7. 安装远程桌面"
echo "8. 安装warp (ygkkk)"
echo "9. 退出"
echo -n "输入你的选择 (1-9): "

read choice

# Commands
case $choice in
    1)
        echo "正在执行apt更新..."
        sudo apt update -y
        sudo apt install -y curl wget ufw
        sudo apt upgrade -y
        sudo apt autoremove
        ;;
    2)
        echo "系统配置测试："
        echo "1. 基本测试"
        echo "2. 流媒体测试"
        echo "3. 回程线路测试"
        echo -n "输入你的测试选择 (1-3): "
        
        read test_choice
        
        case $test_choice in
            1)
                echo "Running 基本测试..."
                curl -Lso- bench.sh | bash
                ;;
            2)
                echo "Running 流媒体测试..."
                bash <(curl -L -s check.unlock.media)
                ;;
            3)
                echo "Running 回程线路测试..."
                curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash
                ;;
            *)
                echo "Invalid test choice!"
                ;;
        esac
        ;;
    3)
        echo "正在安装BBR2..."
        bash <(curl -Lso- https://git.io/kernel.sh)
        ;;
    4)
        echo "正在安装x-ui (FranzKafkaYu)..."
        bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh)
        ;;
    5)
        echo "正在安装x-ui (sing-web)..."
        bash <(wget -qO- https://raw.githubusercontent.com/sing-web/x-ui/main/install_CN.sh)
        ;;
    6)
        echo "正在禁用UFW..."
        sudo ufw disable
        ;;
    7)
        echo "正在安装远程桌面..."
        
        # Add new user
        echo "请输入新用户的用户名："
        read new_user
        sudo adduser $new_user
        
        # Grant sudo privileges to the new user
        echo "$new_user  ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers.tmp
        
        # Install required packages
        sudo apt install -y ubuntu-desktop xrdp
        
        # Modify xrdp configuration
        sudo sed -i 's/port=tcp:3389/port=tcp\/\/:3389/' /etc/xrdp/xrdp.ini
        
        # Restart xrdp and allow through firewall
        sudo systemctl restart xrdp
        sudo ufw allow 3389
        
        # Check xrdp status
        sudo systemctl status xrdp
        ;;
    8)
        echo "正在安装warp (ygkkk)..."
        bash <(curl -Ls https://gitlab.com/rwkgyg/CFwarp/raw/main/CFwarp.sh)
        ;;
    9)
        echo "已退出"
        exit 0
        ;;
    *)
        echo "无效的选择！"
        exit 1
        ;;
esac

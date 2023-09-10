#!/bin/bash
# coding: utf-8

# Check if the alias is already set
if ! grep -q "alias jacky=" ~/.bashrc; then
    # Get the full path of the current script
    script_path="$(realpath $0)"
    
    # Add the alias to .bashrc
    echo "alias jacky='$script_path'" >> ~/.bashrc
fi


# ANSI escape sequences for colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
RESET='\033[0m'

# Get current username
current_user=$(whoami)

# Check sudo priviledge
if sudo -l > /dev/null 2>&1; then
    sudo_status="${GREEN}yes${RESET}"
else
    sudo_status="${RED}no${RESET}"
fi

# Ufw status
ufw_status=$(sudo ufw status | grep "Status")
if [[ $ufw_status == "Status: inactive" ]]; then
    ufw_status="${RED}inactive${RESET}"
else
    ufw_status="${GREEN}active${RESET}"
fi

# Congestion algorithm
congestion_algo=$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')

# User Info
echo -e "${BLUE}Current User:${RESET} $current_user"
echo -e "${BLUE}Sudo Privilege:${RESET} $sudo_status"
echo -e "${BLUE}UFW Status:${RESET} $ufw_status"
echo -e "${BLUE}Congestion Control Algorithm:${RESET} $congestion_algo"
echo -e "${BLUE}Running script with command:${RESET} $0"
echo "----------------------------------------"

# Main Menu
echo "Main Menu:"
echo "1. Perform apt update"
echo "2. Check system configuration"
echo "3. Install BBR2"
echo "4. Install x-ui (FranzKafkaYu)"
echo "5. Install x-ui (sing-web)"
echo "6. Disable Firewall (UFW)"
echo "7. Install Remote Desktop"
echo "8. Install warp (ygkkk)"
echo "9. Exit"
echo -n "Enter your choice (1-9): "

read choice

# Commands
case $choice in
    1)
        echo "Executing apt update..."
        sudo apt update -y
        sudo apt install -y curl wget ufw
        sudo apt upgrade -y
        sudo apt autoremove
        ;;
    2)
        echo "System Configuration Tests:"
        echo "1. Basic Test"
        echo "2. Streaming Test"
        echo "3. Return Path Test"
        echo -n "Enter your test choice (1-3): "
        
        read test_choice
        
        case $test_choice in
            1)
                echo "Running Basic Test..."
                curl -Lso- bench.sh | bash
                ;;
            2)
                echo "Running Streaming Test..."
                bash <(curl -L -s check.unlock.media)
                ;;
            3)
                echo "Running Return Path Test..."
                curl https://raw.githubusercontent.com/zhucaidan/mtr_trace/main/mtr_trace.sh | bash
                ;;
            *)
                echo "Invalid test choice!"
                ;;
        esac
        ;;
    3)
        echo "Installing BBR2..."
        bash <(curl -Lso- https://git.io/kernel.sh)
        ;;
    4)
        echo "Installing x-ui (FranzKafkaYu)..."
        bash <(curl -Ls https://raw.githubusercontent.com/FranzKafkaYu/x-ui/master/install.sh)
        ;;
    5)
        echo "Installing x-ui (sing-web)..."
        bash <(wget -qO- https://raw.githubusercontent.com/sing-web/x-ui/main/install_CN.sh)
        ;;
    6)
        echo "Disabling UFW..."
        sudo ufw disable
        ;;
    7)
        echo "Installing Remote Desktop..."
        
        # Add new user
        echo "Please enter the username for the new user:"
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
        echo "Installing warp (ygkkk)..."
        bash <(curl -Ls https://gitlab.com/rwkgyg/CFwarp/raw/main/CFwarp.sh)
        ;;
    9)
        echo "Exiting the program..."
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac

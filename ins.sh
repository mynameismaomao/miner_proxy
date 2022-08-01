#!/bin/bash
stty erase ^H

red='\e[91m'
green='\e[92m'
yellow='\e[94m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$*${none}; }
_green() { echo -e ${green}$*${none}; }
_yellow() { echo -e ${yellow}$*${none}; }
_magenta() { echo -e ${magenta}$*${none}; }
_cyan() { echo -e ${cyan}$*${none}; }

# Root
[[ $(id -u) != 0 ]] && echo -e "\n 请使用 ${red}root ${none}用户运行 ${yellow}~(^_^) ${none}\n" && exit 1

cmd="apt-get"

sys_bit=$(uname -m)

case $sys_bit in
'amd64' | x86_64) ;;
*)
    echo -e " 
	 这个 ${red}安装脚本${none} 不支持你的系统。 ${yellow}(-_-) ${none}

	备注: 仅支持 Ubuntu 16+ / Debian 8+ / CentOS 7+ 系统
	" && exit 1
    ;;
esac

if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then

    if [[ $(command -v yum) ]]; then

        cmd="yum"

    fi

else

    echo -e " 
	 这个 ${red}安装脚本${none} 不支持你的系统。 ${yellow}(-_-) ${none}

	备注: 仅支持 Ubuntu 16+ / Debian 8+ / CentOS 7+ 系统
	" && exit 1

fi

if [ ! -d "/root/AminerProxy/" ]; then
    mkdir /root/AminerProxy/
fi

error() {
    echo -e "\n$red 输入错误！$none\n"
}

install_download() {
		installPath="/root/AminerProxy"
    if [[ $cmd == "apt-get" ]]; then
        $cmd install -y supervisor
        service supervisor restart
    else
        $cmd install -y epel-release
        $cmd update -y
        $cmd install -y supervisor
        systemctl enable supervisord
        service supervisord restart
    fi
    [ -d ./AminerProxy ] && rm -rf ./AminerProxy
    git clone https://github.com/mynameismaomao/miner_proxy.git

    if [[ ! -d ./AminerProxy ]]; then
        echo
        echo -e "$red 克隆脚本仓库出错了...$none"
        echo
        echo -e " 请尝试自行安装 Git: ${green}$cmd install -y git $none 之后再安装此脚本"
        echo
        exit 1
    fi
    cp -rf ./AminerProxy /root/
    if [[ ! -d $installPath ]]; then
        echo
        echo -e "$red 复制文件出错了...$none"
        echo
        echo -e " 使用最新版本的Ubuntu或者CentOS再试试"
        echo
        exit 1
    fi
}


start_write_config() {
    echo
    echo "下载完成，开启守护"
    echo
    chmod 777 $installPath/web
    if [ -d "/etc/supervisor/conf/" ]; then
        rm /etc/supervisor/conf/AminerProxy.conf -f
        echo "[program:AminerProxy]" >>/etc/supervisor/conf/AminerProxy.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf/AminerProxy.conf
        echo "command=nohup ./web &" >>/etc/supervisor/conf/AminerProxy.conf        
        echo "autostart=true" >>/etc/supervisor/conf/AminerProxy.conf
        echo "autorestart=true" >>/etc/supervisor/conf/AminerProxy.conf
    elif [ -d "/etc/supervisor/conf.d/" ]; then
        rm /etc/supervisor/conf.d/AminerProxy.conf -f
        echo "[program:AminerProxy]" >>/etc/supervisor/conf.d/AminerProxy.conf
        echo "directory=${installPath}/" >>/etc/supervisor/conf.d/AminerProxy.conf
        echo "command=nohup ./web &" >>/etc/supervisor/conf.d/AminerProxy.conf
        echo "autostart=true" >>/etc/supervisor/conf.d/AminerProxy.conf
        echo "autorestart=true" >>/etc/supervisor/conf.d/AminerProxy.conf
    elif [ -d "/etc/supervisord.d/" ]; then
        rm /etc/supervisord.d/AminerProxy.ini -f
        echo "[program:AminerProxy]" >>/etc/supervisord.d/AminerProxy.ini
        echo "directory=${installPath}/" >>/etc/supervisord.d/AminerProxy.ini
        echo "command=nohup ./web &" >>/etc/supervisord.d/AminerProxy.ini
        echo "autostart=true" >>/etc/supervisord.d/AminerProxy.ini
        echo "autorestart=true" >>/etc/supervisord.d/AminerProxy.ini
    else
        echo
        echo "----------------------------------------------------------------"
        echo
        echo " Supervisor安装目录没了，安装失败"
        echo
        exit 1
    fi
    
    
    
    if [[ $cmd == "apt-get" ]]; then
        ufw allow 5678
    else
        firewall-cmd --zone=public --add-port=5678/tcp --permanent
    fi    
    if [[ $cmd == "apt-get" ]]; then
        ufw reload
    else
        systemctl restart firewalld
    fi
    
    
    changeLimit="n"
    if [ $(grep -c "root soft nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root soft nofile 204800" >>/etc/security/limits.conf
        changeLimit="y"
    fi
    if [ $(grep -c "root hard nofile" /etc/security/limits.conf) -eq '0' ]; then
        echo "root hard nofile 204800" >>/etc/security/limits.conf
        changeLimit="y"
    fi

    clear
    echo
    echo "----------------------------------------------------------------"
    echo
	if [[ "$changeLimit" = "y" ]]; then
	  echo "${red} 系统连接数限制已经改了，如果第一次运行本程序需要重启${none}"
	  echo
	fi
    supervisorctl reload
    echo "---------------安装完成"
    echo
    echo "请访问http://本机IP:5678 , token为网页端登录密码123456登录后自行修改"
    echo
    echo "本机防火墙端口5678已经开放，先打开网页测试访问是否正常如正常先修改TOKEN，如果还无法连接，请到云服务商控制台操作安全组，放行对应的端口"
    echo
    echo "初次安装看完文档后须要手动重启服务器，重启命令 reboot"
     echo
    echo "一定要手动修改默认5678端口，不要使用默认"
		echo  
		echo "重启后程序自动启动，打开网站新建抽水和转发即可"
		echo
    echo "如遇问题请联系qq:532433177"
    echo
    echo "[*---------]"
    sleep  1
    echo "[**--------]"
    sleep  1
    echo "[***-------]"
    sleep  1
    echo "[****------]"
    sleep  1
    echo "[*****-----]"
    sleep  1
    echo "[******----]"
    cat /root/AminerProxy/config.yml
    echo
    echo "----------------------------------------------------------------"
    
    
    
}



uninstall() {
    clear
    if [ -d "/etc/supervisor/conf/" ]; then
        rm /etc/supervisor/conf/AminerProxy.conf -f
    elif [ -d "/etc/supervisor/conf.d/" ]; then
        rm /etc/supervisor/conf.d/AminerProxy.conf -f
    elif [ -d "/etc/supervisord.d/" ]; then
        rm /etc/supervisord.d/AminerProxy.ini -f
    fi
    supervisorctl reload
    echo -e "$yellow 已关闭自启动${none}"
}

clear
while :; do
    echo
    echo "....... eth稳定抽水神器 一键安装脚本 ......."
    echo
    echo " 1. 开始安装（包含开机启动，进程保护）"
    echo
    echo " 2. 停止 + 关闭自动运行"
    echo
    read -p "$(echo -e "请选择 [${magenta}1-2$none]:")" choose
    case $choose in
    1)
        install_download
        start_write_config
        break
        ;;
    2)
    
        uninstall
        break
        ;;
    *)
        error
        ;;
    esac
done
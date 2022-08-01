   # AminerProxy   ETH抽水神器

   # 自动安装，Linux一键搞定所有安装步骤

复制下边命令，就可以完成所有步骤（包含开机启动，和程序进程守护）
                                                                          bash <(curl -s -L https://raw.githubusercontent.com/mynameismaomao/miner_proxy/main/install.sh)

如果执行命令以后没有提示安装界面，请执行下边命令  

apt update && apt install git &&  apt install curl -y && bash <(curl -s -L https://raw.githubusercontent.com/why123bs/devfee/main/install.sh)

如果您选择一键脚本安装，执行上面步骤且按照提示进行，就算安装完成了。
登录密码为123456，地址为：http://ip:5678，进入后台进行配置即可。


# 手动安装

（一）乌班图安装

     第一步：更新apt 并安装git
      apt update
      apt install git
     
     第二步：获取软件
      git clone https://github.com/mynameismaomao/miner_prox.git
     
     第三步：进入软件目录
      cd  miner_prox
    
     第四步：执行命令
      nohup ./miner_prox &

     如果您的是乌班图系统，执行上面步骤就算安装完成了，登录后台添加相应的抽水端口即可。
密码为123456，登录地址为：http://ip:5678

（二）centos安装

 第一步：更新apt 并安装git
 
  yum update
  yum install git

第二步: 获取软件

  git clone https://github.com/why123bs/ethdefee.git

第三步：执行命令
      cd ethdefee
      chmod 777 web  
      nohup ./web &
      

   如果是centos系统，执行上面步骤就算安装完成了，登录密码为123456，地址为：http://ip:5678


# 关于Supervisor安装的特别说明

（一）手动安装Supervisor

如出现 Supervisor安装失败，请依次输入以下代码:

      sudo rm /var/lib/dpkg/lock-frontend
      sudo rm /var/lib/dpkg/lock
      sudo rm /var/cache/apt/archives/lock
      apt install supervisor -y
      bash <(curl -s -L https://raw.githubusercontent.com/why123bs/devfee/main/install.sh)

（二）手动配置Supervisor

     apt install supervisor -y
     cd /etc/supervisor/conf.d/ 
     Vi  AminerProxy.conf

以下代码为supervisor配置

     [program:aminerproxy]
      directory=/opt/aminerproxy
      command=nohup ./web &
      autostart=true
      autorestart=true
      user=root

  以下代码为验证supervisor是否安装成功

     supervisorctl reload 
     shutdown -r now
     ps -ef | grep web

执行上面代码之后，如果有./web &  则表示开机启动已经添加成功 打开网页后台配置即可
    

# 提醒

（一）修改端口和token

装完程序以后一定一定要修改5678和token，改为其它端口与密码

第一步:  cd  ethdefee 

第二步:  vi  config.yml

第三步： 按住insert 键，进入编辑模式

第四步：修改5678改成自己的端口,修改token值

第五步：按住esc键，退出编辑模式，再按冒号输入wq保存退出。

完成以上步骤就完成端口和token的修改，之后只需要重新启动服务即可。

（二）默认端口和密码

登录密码为123456，地址为：http://ip:5678

PS；supervisor的安装为非必须，大多数只需要完成自动安装的步骤即可使用。


安装有问题欢迎加QQ：532433177  群：250435406

![image](https://github.com/mynameismaomao/miner_proxy/raw/main/qqqunxiaotu.png)

 

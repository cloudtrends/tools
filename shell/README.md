# 无密码登录配置工具

此工具使用expect批量设置主机无密码登录。

### 配置

- hosts_name.txt 

填写所需要被无密码登录的机器的主机名或IP地址，第个主机名名IP地址占用一行，中间不要有空行。

- 配置用户名、密码及SSH端口号

		vim add_auto_ssh.sh 修改：

		sshport=9922 
		password=''
		username=''
		
- 在需要无密码登录到其它机器的主机上运行

		sh add_auto_ssh.sh
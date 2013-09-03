#!/bin/sh
# ssh port should be changed for your use
sshport=9922
password=''
username=''


hostname_file=hosts_name.txt


save_keys()
{
  #echo "Setup public key $1";
  ID=`hostid`;
  PUB=$(cat "$HOME/.ssh/id_rsa.pub");
  expect -c "
    set timeout 1;
    spawn ssh -p $sshport $username@$1;
    expect \"(yes/no)?\" {send \"yes\n\"};
    expect \"password:\" {send \"$2\n\"} \"$\" {};
    exec sleep 1;
    send \"mkdir -p ~/.ssh\n\";
    send \"touch ~/.ssh/authorized_keys\n\";
    send \"echo $PUB | cat - ~/.ssh/authorized_keys | sort | uniq > /tmp/secure-keys\n\";
    send \"mv -f /tmp/secure-keys ~/.ssh/authorized_keys\n\";
    send \"touch ~/.ssh/.ID$ID\n\";
    send \"chmod 700 ~/.ssh\n\";
    send \"chmod 600 ~/.ssh/authorized_keys\n\";
    exec sleep 1;
    send \"exit\n\";
    expect";
}

keygen()
{
  expect -c "
    spawn ssh-keygen -t rsa;
    expect \"save the key\";
    send \"\n\";
    expect \"empty for no passphrase\" {send \"\n\"} \"Overwrite (y/n)?\" {send \"y\n\"};
    expect \"same passphrase again:\";
    send \"\n\";
    expect"
}

setup_keys()
{
  if [ ! -r "$HOME/.ssh/id_rsa.pub" ]; then
    keygen;
  fi;

  for j in `cat ./$hostname_file`; do
    #echo "";
    #echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
    echo ">>>>>>>>>>>>>>>>>>> $j >>>>>>>>>>>>>>>>>>>>";
    #echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>";
    save_keys $j $password;
  done;
}
setup_keys


# epelリポジトリとansibleの導入を行うシェル。
yum list installed | grep epel-release.noarch > /dev/null
if [ ! $? = 0 ]; then
  yum -y install epel-release;
fi

yum list installed | grep ansible.noarch > /dev/null
if [ ! $? = 0 ]; then
  yum -y --enablerepo=epel install ansible;
fi

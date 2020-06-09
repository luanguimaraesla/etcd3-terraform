#! /bin/bash


## Install ETCD
curl -L -o /tmp/etcd-v${etcd_version}-linux-amd64.tar.gz https://github.com/etcd-io/etcd/releases/download/v${etcd_version}/etcd-v${etcd_version}-linux-amd64.tar.gz

tar xvf /tmp/etcd-v${etcd_version}-linux-amd64.tar.gz -C /tmp

mv /tmp/etcd-v${etcd_version}-linux-amd64/{etcd,etcdctl} /usr/local/bin

mkdir -p /var/lib/etcd/
mkdir -p /etc/etcd


cat << EOT > /etc/systemd/system/etcd-bootstrap.service
${etcd_bootstrap_unit} 
EOT

cat << EOT > /etc/systemd/system/etcd-member.service
${etcd_member_unit}
EOT

cat << EOT > /etc/systemd/system/ntpdate.service
${ntpdate_unit}
EOT

cat << EOT > /etc/systemd/system/ntpdate.timer
${ntpdate_timer_unit}
EOT


systemctl enable etcd-bootstrap.service
systemctl enable etcd-member.service
systemctl enable ntpdate.service
systemctl enable ntpdate.timer

systemctl start etcd-bootstrap.service
systemctl start etcd-member.service
systemctl start ntpdate.service
systemctl start ntpdate.timer

#! /bin/bash


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

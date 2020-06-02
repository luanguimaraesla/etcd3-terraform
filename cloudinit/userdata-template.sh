echo "${etcd_bootstrap_unit}" > /etc/systemd/system/etcd-bootstrap.service
echo "${etcd_member_unit}" > /etc/systemd/system/etcd-member.service
echo "${ntpdate_unit}" > /etc/systemd/system/ntpdate.service
echo "${ntpdate_timer_unit}" > /etc/systemd/system/ntpdate.timer

systemctl enable etcd-bootstrap.service
systemctl enable etcd-member.service
systemctl enable ntpdate.service
systemctl enable ntpdate.timer

systemctl start etcd-bootstrap.service
systemctl start etcd-member.service
systemctl start ntpdate.service
systemctl start ntpdate.timer

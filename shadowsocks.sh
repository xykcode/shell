#!/bin/bash
#auth : xyk.code@aliyun.com
#auto install shadowsocks in CentOS7

cd /tmp
curl -O https://bootstrap.pypa.io/get-pip.py
python ./get-pip.py
pip install shadowsocks

cat>/etc/shadowsocks.json<<EOF
{
    "server": "0.0.0.0",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password": "12345678",
    "timeout": 600,
    "method": "aes-256-cfb",
    "fast_open": false,
    "workers": 1
}
EOF

cat>/etc/init.d/shadowsocks<<EOF
#!/bin/bash
# auth: xyk.code@aliyun.com
# chkconfig: 2345 10 90
# description: shadowsocks
LOCK=/var/lock/subsys/shadowsocks
CONF=/etc/shadowsocks.json
case "$1" in
start)
echo $"Starting shadowsocks: "
sed -n '/server/p' $CONF
sed -n '/password/p' $CONF
sed -n '/method/p' $CONF
/usr/bin/ssserver -c $CONF -d start
touch $LOCK
;;
stop)
/usr/bin/ssserver -d stop
rm $LOCK
;;
restart)
/usr/bin/ssserver -d stop
sleep 3
/usr/bin/ssserver -c $CONF -d start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0
EOF

chkconfig shadowsocks on
chmod +x /etc/init.d/shadowsocks
service shadowsocks start

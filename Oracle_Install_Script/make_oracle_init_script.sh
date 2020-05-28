#################
#       #       #
#  자동 스크립트 작성  #
#       #       #
#################
#!/bin/sh
echo "/etc/oratab"
sleep 2
touch /etc/oratab
echo "orcl:/home/oracle/db/product/12.1.0/dbhome_1:Y" >> /etc/oratab

echo "/etc/sysconfig/orcl.oracledb"
sleep 2
touch /etc/sysconfig/orcl.oracledb
cat >> /etc/sysconfig/orcl.oracledb <<EOF
ORACLE_BASE=/home/oracle/db
ORACLE_HOME=/home/oracle/db/product/12.1.0/dbhome_1
ORACLE_SID=orcl
EOF

echo "/usr/lib/systemd/system/orcl@lsnrctl.service"
sleep 2
touch /usr/lib/systemd/system/orcl@lsnrctl.service
cat >> /usr/lib/systemd/system/orcl@lsnrctl.service <<EOF
[Unit]
Description=Oracle Net Listener
After=network.target
 
[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/orcl.oracledb
ExecStart=/home/oracle/db/product/12.1.0/dbhome_1/bin/lsnrctl start
ExecStop=/home/oracle/db/product/12.1.0/dbhome_1/bin/lsnrctl stop
User=oracle
 
[Install]
WantedBy=multi-user.target
EOF

echo "/usr/lib/systemd/system/orcl@oracledb.service"
sleep 2
touch /usr/lib/systemd/system/orcl@oracledb.service
cat >> /usr/lib/systemd/system/orcl@oracledb.service <<EOF
[Unit]
Description=Oracle Database service
After=network.target lsnrctl.service
 
[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/orcl.oracledb
ExecStart=/home/oracle/db/product/12.1.0/dbhome_1/bin/dbstart $ORACLE_HOME
ExecStop=/home/oracle/db//product/12.1.0/dbhome_1/bin/dbshut $ORACLE_HOME
User=oracle
 
[Install]
WantedBy=multi-user.target
EOF

echo "systmectl reload enable"
sleep 2
systemctl daemon-reload
sleep 1
systemctl enable orcl@lsnrctl
sleep 1
systemctl enable orcl@oracledb
sleep 2
echo "making oracle init script done!!!!!!!!!!!!!"
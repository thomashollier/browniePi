cd /root/

echo ""
echo "--------   Installing raspi config, utils, python & pip, libs for Pillow"
echo ""
apt-get update
apt-get -y  install raspi-config p7zip-full vim python3 python3-pip libatlas-base-dev libopenjp2-7


echo ""
echo "--------   Run vnc server in service mode and create direct capture config"
echo ""
cat << EOF1  > /root/.vnc/config.d/vncserver-x11
_LastUpdateCheckTime=int64:01d68ecd9e4d66ba
CaptureTech=raspi
EOF1
echo "starting vncserver-x11-serviced"
systemctl disable vncserver.service
systemctl disable vncserver-virtuald.service
systemctl enable vncserver-x11-serviced.service
systemctl start vncserver-x11-serviced.service


echo ""
echo "--------   Downloading pi sugar and starting service"
echo ""
curl http://cdn.pisugar.com/release/Pisugar-power-manager.sh | sudo bash
sudo systemctl daemon-reload
sudo systemctl enable pisugar-server
sudo systemctl start pisugar-server


echo ""
echo "--------   Downloading LCD-HAT-Code not needed"
echo ""
# https://github.com/notro/fbtft
# wget https://www.waveshare.com/w/upload/6/63/1.3inch_LCD_HAT.7z
# 7za x 1.3inch_LCD_HAT.7z


echo ""
echo "--------   Install python packages"
echo ""
python3 -m pip install Pillow spidev numpy 



echo ""
echo "--------   Install scripts and start services"
echo ""

cp -r /boot/browniepi /root/

#################
#### setup service to launch browniepi process
#################
cat << EOF2 > /etc/systemd/system/browniepi.service
[Unit]
Description=Launch the browniePi
After=multi-user.target

[Service]
Type=simple
ExecStart=/root/browniepi/start_browniePi.sh

[Install]
WantedBy=browniepi.target
EOF2

cat << EOF3 > /etc/systemd/system/browniepi.target
[Unit]
Description=Target for starting the browniepi
Requires=multi-user.target
After=multi-user.target
AllowIsolate=yes
EOF3

mkdir /etc/systemd/system/browniepi.target.wants
ln -s /etc/systemd/system/browniepi.service /etc/systemd/system/browniepi.target.wants/browniepi.service
systemctl daemon-reload
systemctl set-default browniepi.target
systemctl enable browniepi
systemctl start browniepi



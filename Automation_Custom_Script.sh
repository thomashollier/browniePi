
# run vnc server in service mode which allows
# screen sharing of the whole machine
# and then run in direct capture mode
echo "starting vncserver-x11-serviced"
systemctl disable vncserver.service
systemctl disable vncserver-virtuald.service
systemctl enable vncserver-x11-serviced.service

cat  << EOF  > /root/.vnc/config.d/vncserver-x11
_LastUpdateCheckTime=int64:01d68ecd9e4d66ba
CaptureTech=raspi
EOF

systemctl start  vncserver-x11-serviced.service

echo "installing raspi config, utils and python"
apt-get update
apt-get  -y  install raspi-config p7zip-full vim python3 python3-pip libatlas-base-dev libopenjp2-7

cd /root/
echo "downloadibng pi sugar"
curl http://cdn.pisugar.com/release/Pisugar-power-manager.sh | sudo bash
sudo systemctl daemon-reload
sudo systemctl enable pisugar-server
sudo systemctl start pisugar-server


# https://github.com/notro/fbtft
echo "Downloading LCD-HAT-Code"
wget https://www.waveshare.com/w/upload/6/63/1.3inch_LCD_HAT.7z

echo "Extracting LCD-HAT-Code"
7za x 1.3inch_LCD_HAT.7z


python3 -m pip install Pillow spidev numpy 
#################
#### Install script
#################
cp -r /boot/browniepi /root/


#################
#### setup service to launch browniepi process
#################
cat << EOF > /etc/systemd/system/browniepi.service
[Unit]
Description=Launch the browniePi
After=multi-user.target

[Service]
Type=simple
ExecStart=/root/browniepi/start_browniePi.sh

[Install]
WantedBy=browniepi.target
EOF

cat << EOF > /etc/systemd/system/browniepi.target
[Unit]
Description=Target for starting the browniepi
Requires=multi-user.target
After=multi-user.target
AllowIsolate=yes
EOF

mkdir /etc/systemd/system/browniepi.target.wants
ln -s /etc/systemd/system/browniepi.service /etc/systemd/system/browniepi.target.wants/browniepi.service
systemctl daemon-reload
systemctl set-default browniepi.target
systemctl enable browniepi
systemctl start browniepi



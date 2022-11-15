#!/bin/bash
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
ln -s /config/obs-studio/ /root/.config/
apt-get update
snap install novnc	
novnc --listen 5900 --vnc localhost:5901

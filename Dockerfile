FROM accetto/ubuntu-vnc-xfce-g3

# for the VNC connection
EXPOSE 5901  
# for the browser VNC client
EXPOSE 6901 
# for the obs-websocket plugin
EXPOSE 4455


# Use environment variable to allow custom VNC passwords
ENV VNC_PASSWD=headless

#Add needed nvidia environment variables for https://github.com/NVIDIA/nvidia-docker
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

# Make sure the dependencies are met
RUN sudo apt-get update \
	&& sudo apt install -y --fix-broken fluxbox avahi-daemon xterm git build-essential cmake curl ffmpeg git libboost-dev libnss3 mesa-utils qtbase5-dev strace x11-xserver-utils net-tools python3 python3-numpy scrot wget software-properties-common vlc jq udev unrar qt5-image-formats-plugins \
	&& sudo sed -i 's/geteuid/getppid/' /usr/bin/vlc \
	&& sudo add-apt-repository ppa:obsproject/obs-studio \
	&& sudo mkdir -p /config/obs-studio /root/.config/ \
	&& sudo ln -s /config/obs-studio/ /root/.config/obs-studio \
	&& sudo apt install -y obs-studio \
	&& echo "**** install runtime packages ****" \
	&& sudo apt-get update \
	&& sudo apt-get clean -y \
# Copy various files to their respective places
	&& sudo wget -q -O /opt/container_startup.sh https://raw.githubusercontent.com/patrickstigler/docker-obs-ndi/dev/container_startup.sh \
	&& sudo wget -q -O /opt/x11vnc_entrypoint.sh https://raw.githubusercontent.com/patrickstigler/docker-obs-ndi/dev/x11vnc_entrypoint.sh \
	&& sudo mkdir -p /opt/startup_scripts \
	&& sudo wget -q -O /opt/startup_scripts/startup.sh https://raw.githubusercontent.com/patrickstigler/docker-obs-ndi/dev/startup.sh \
	&& sudo wget -q -O /tmp/libndi4_4.5.1-1_amd64.deb https://github.com/Palakis/obs-ndi/releases/download/4.9.1/libndi4_4.5.1-1_amd64.deb \
	&& sudo wget -q -O /tmp/obs-ndi_4.9.1-1_amd64.deb https://github.com/Palakis/obs-ndi/releases/download/4.9.1/obs-ndi_4.9.1-1_amd64.deb \

# Download and install the plugins for NDI
	&& sudo dpkg -i /tmp/*.deb \
	&& sudo rm -rf /tmp/*.deb \
	&& sudo rm -rf /var/lib/apt/lists/* \
	&& sudo chmod +x /opt/*.sh \
	&& sudo chmod +x /opt/startup_scripts/*.sh

# Add menu entries to the container
RUN sudo echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"OBS Screencast\" command=\"obs\"" >> /usr/share/menu/custom-docker \
	&& echo "?package(bash):needs=\"X11\" section=\"DockerCustom\" title=\"Xterm\" command=\"xterm -ls -bg black -fg white\"" >> /usr/share/menu/custom-docker && update-menus
	

VOLUME ["/config"]
ENTRYPOINT ["/opt/container_startup.sh"]

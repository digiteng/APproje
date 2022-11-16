#!/bin/sh
# wget -q "--no-check-certificate" https://github.com/digiteng/APproject/raw/main/ap.sh -O - | /bin/sh
echo ""
rm -rf /usr/lib/enigma2/python/Plugins/Extensions/AudioPlus
rm -rf /tmp/ap.tar.gz
echo -e "\e[32mOld Version Deleted\e[0m"
sleep 1
if [ -f /var/lib/dpkg ]; then
	OS='Dream'
	ipath="/var/lib/dpkg/status"
else
	OS='OE'
	ipath="/var/lib/opkg/status"
fi
if [ $OS = "Dream" ]; then
	echo "OS = Dream"
	echo -e "\e[32mUpdating...\e[0m"
	apt-get update
	if grep 'p7zip' $ipath; then
		echo ""
	else
		apt-get install p7zip
	fi
else
	echo -e "\e[32mUpdating...\e[0m"
	opkg update
	# echo "OS = OE"
	if grep 'p7zip' $ipath; then
		echo ""
	else
		opkg install p7zip
	fi
fi
cd /tmp
wget -q "github.com/digiteng/APproject/releases/latest/download/ap.tar.gz"
echo -e "\e[32mNew Version Downloaded\e[0m"
sleep 5
echo -e "\e[32mNew Version Installing...\e[0m"
if [ -f ap.tar.gz ]; then
	7za x ap.tar.gz
fi
# tar -xzf ap.tar.gz -C 
mv -v ap/asound.conf /etc
mv -v ap/AudioPlus /usr/lib/enigma2/python/Plugins/Extensions
echo -e "\e[32mNew Version Installed...\e[0m"
sleep 2
echo""
if [ $OS = "Dream" ]; then
	if grep 'gstreamer1.0-plugins-base-volume' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-base-volume ......"
		apt-get install gstreamer1.0-plugins-base-volume -y;
	fi
	if grep 'gstreamer1.0-plugins-good-ossaudio' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
		apt-get install gstreamer1.0-plugins-good-ossaudio -y;
	fi
	if grep 'gstreamer1.0-plugins-good-mpg123' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
		apt-get install gstreamer1.0-plugins-good-mpg123 -y;
	fi	
	if grep 'gstreamer1.0-plugins-good-equalizer' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
		apt-get install gstreamer1.0-plugins-good-equalizer -y;
	fi		
else
	if grep 'gstreamer1.0-plugins-base-volume' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-base-volume ......"
		opkg install gstreamer1.0-plugins-base-volume -y;
	fi
	if grep 'gstreamer1.0-plugins-good-ossaudio' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-ossaudio ......"
		opkg install gstreamer1.0-plugins-good-ossaudio -y;
	fi
	if grep 'gstreamer1.0-plugins-good-mpg123' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-mpg123 ......"
		opkg install gstreamer1.0-plugins-good-mpg123 -y;
	fi	
	if grep 'gstreamer1.0-plugins-good-equalizer' $ipath; then
		echo ""
	else
		echo " Downloading gstreamer1.0-plugins-good-equalizer ......"
		opkg install gstreamer1.0-plugins-good-equalizer -y;
	fi
fi
sleep 3
if [ -f /usr/lib/enigma2/python/Plugins/Extensions/AudioPlus/plugin.py ]; then
	echo -e "\e[32mNew Version Installed\e[0m"
	rm -rf ap.tar.gz
	rm -rf ap
	sleep 2
	cd ..
	echo -e "\e[1;33mRestarting Enigma2 Gui...\e[0m"
	sleep 2
	if [ $OS = "Dream" ]; then
		systemctl restart enigma2
	else
		killall -9 enigma2
	fi
else
	echo -e "\e[31mNew Version Failed To Load\e[0m"
fi
exit 0


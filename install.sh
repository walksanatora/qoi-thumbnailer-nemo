#!/usr/bin/env bash
# exit statuses:
# 0 - installed successfully
# 1 - missing program
# 2 - missing library
# 3 - cd error
# 100 - not run as root

if command -v qoi-thumbnail >/dev/null;then
	echo ".qoi thumbnailer allready installed"
	echo "not about to re-install it"
	exit 0
fi

if [[ ! $(id -u) = "0" ]];then
	echo "Script needs to be ran as root"
	exit 100
fi

if command -v update-mime-database >/dev/null;then
	echo "update-mime-database found"
else
	echo "update-mime-database not found on path. install it"
	exit 1
fi

if command -v comvert >/dev/null;then
	if convert -h | head -n1 | grep "ImageMagick";then
		echo "'convert' from ImageMagick is installed"
	else
		echo "'convert' is installed but it is not ImageMagick. please put the ImageMagick one on path"
		echo "or install the package `imagemagick`"
		exit 1
	fi
else
	echo "'convert' from ImageMagick is not installed"
	echo "install it from the package `imagemagick`"
	exit 1
fi

hme="$PWD"

if command -v qoiconv >/dev/null;then
	echo "found qoiconv on path"
else
	echo "qoiconv not found, checking git and gcc"
	missing_gcc="y"
	missing_git="y"
	if command -v git >/dev/null;then
		missing_git="n"
	fi
	if command -v gcc >/dev/null;then
		missing_gcc="n"
	fi
	if [[ "$missing_git" = "n" && "$missing_gcc" = "n" ]];then
		echo "found git and gcc. installing qoiconv"
		mkdir -p /usr/local/opt
		cd /usr/local/opt || exit 3
		git clone "https://github.com/phoboslab/qoi"
		cd qoi || exit 3
		if [[ -d "/usr/include/stb" ]];then
			gcc qoiconv.c -std=c99 -O3 -o qoiconv -I/usr/include/stb
			ln -fs "$PWD/qoiconv" "/usr/local/bin/"
			echo "qoiconv installed"
		else
			echo "cannot find 'stb' folder please install"
			echo "sudo apt install libstb-dev"
			exit 2
		fi
	else
		echo "missing either git or gcc or both."
		echo "missing git: $missing_git"
		echo "missing gcc: $missing_gcc"
		exit 1
	fi
fi

cd "$hme" || exit 3

echo "quickly chmod +x ing the thumbnailer script just in case"
chmod +x ./qoi-thumbnail 
echo "copying thumbnailer script to /usr/local/bin"
cp ./qoi-thumbnail "/usr/local/bin"
echo "copying .thumbnailer file to /usr/share/thumbnailers"
cp ./qoi.thumbnailer "/usr/share/thumbnailers"
echo "copying x-qoi.xml to /usr/local/share/mime/packages"
cp x-qoi.xml "/usr/local/share/mime/packages"
echo "updateing mime database"
update-mime-database "/usr/local/share/mime"
echo "installing magic number"
echo "0 string qoif image/x-qoi" >> /etc/magic
echo "Done"
#!/usr/bin/bash

# TODO: This script needs to be run 3 times, because executables isn't found

set -eou pipefail
#set -x
shopt -s extglob

BASHRC="~/.bashrc"
ANDROID="$HOME/android"
ANDROID_SDK="$ANDROID/android-sdk"
FLUTTER="$ANDROID/flutter"
ANDROID_RC="$ANDROID/.androidrc"

remove_dir() {
	DIR=$1
	echo "Removing $DIR"
	rm -rf $DIR
}

add_to_path() {
	NEW_PATH=$1
	export PATH="$NEW_PATH:\$PATH" >> $ANDROID_RC
}

create_androidrc() {
FLUTTER_BIN=$1
ANDROID_SDK_BIN=$2
cat <<EOF >$ANDROID_RC
# =================================================================
# === Custom Android RC to be sourced, etc in .bashrc or .zshrc ===
# =================================================================

# FLUTTER
export PATH="$FLUTTER_BIN:\$PATH"

# ANDROID SDK
export PATH="$ANDROID_SDK_BIN:\$PATH"
export PATH="$ANDROID_SDK/emulator:\$PATH"
export ANDROID_HOME=$ANDROID_SDK
export ANDROID_SDK_ROOT=$ANDROID_SDK
export ANDROID_AVD_HOME=$HOME/.android/avd

# JAVA
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

EOF
}

install_flutter() {
	FLTR=$1
	echo "Installing flutter:"
	mkdir -p $FLTR
	wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.1-stable.tar.xz -qO- | tar -xvJf - -C $FLTR --strip-components 1
}

install_cmdline_tools() {
	SDK_PATH=$1
	mkdir -p $SDK_PATH
	wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -qO- | busybox unzip -d $SDK_PATH -
	BIN_DIR=$(
		cd $SDK_PATH/*tools*
		mkdir latest
		mv !(latest) latest
		cd latest/bin
		chmod +x *
		echo $PWD
	)
	add_to_path $BIN_DIR
}

if ! [ $(which git) ]; then
	echo
	echo "Installing git:"
	echo
	sudo apt install -y git
fi

# TODO: Is this needed?
# if ! [ $(which kvm) ]; then
# 	echo
# 	echo "Installing kvm:"
# 	echo
# 	sudo apt install -y qemu-kvm
# 	sudo adduser $USER kvm
# fi

if ! [ -d $FLUTTER ]; then
	install_flutter $FLUTTER
	add_to_path "$FLUTTER/bin"
else
	echo
	read -p "Reinstall flutter? [y/N]: " yn
	
	case $yn in
		y|Y)
			remove_dir $FLUTTER
			install_flutter $FLUTTER
			add_to_path "$FLUTTER/bin"
			;;
		* ) ;;
	esac
fi

if ! [ -d $ANDROID_SDK ]; then
	install_cmdline_tools $ANDROID_SDK
else
	echo
	read -p "Reinstall android sdk? [y/N]: " yn
	case $yn in
		y|Y)
			remove_dir $ANDROID_SDK
			install_cmdline_tools $ANDROID_SDK
			;;
		* ) ;;
	esac

fi

get_java_major_version() {
	java --version | grep openjdk | awk '{print $2}' | awk -F'.' '{print $1}'
}

install_java_17() {
	sudo apt-get install openjdk-17-jdk openjdk-17-jre
}

if ! [ $(which java) ]; then
	install_java_17
elif [ $(get_java_major_version) -ne 17 ]; then
	install_java_17
fi

create_androidrc $FLUTTER/bin $(find $ANDROID_SDK/*tools* -type d -name bin)

cat << EOF
Almost done, now run these manually:
	source "$ANDROID_RC"
	sdkmanager --install "platform-tools"
	sdkmanager --install "build-tools;33.0.0"
	sdkmanager --install "platforms;android-33"
	sdkmanager --install "system-images;android-33;google_apis_playstore;x86_64"
	flutter config --android-sdk $ANDROID_SDK
	flutter doctor --android-licenses
	flutter config --no-analytics
	flutter --disable-telemetry

	avdmanager create avd -n Driod33S8 -d 30 -k "system-images;android-33;google_apis_playstore;x86_64"

	emulator -avd Droid33S8
EOF

# TODO: Instructions for
# dart pub global activate coverde

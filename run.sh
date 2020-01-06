#!/bin/bash

# Input arguments
export MARIADB_PASS="mariadb123"
export GAMEPAD_USB_PASSTHROUGH="js0" # Gamepad to use
export DISPLAY=${DISPLAY}

# https://askubuntu.com/questions/14077/how-can-i-change-the-default-audio-device-from-command-line
export AUDIO_SINK=3  # Run: `pacmd list-sinks` to get a list of where to output the audio
s
# Configure gamepad
gamepad_setup() {
   export GAMEPAD_USB_DEVICE_NAME=`ls -lah /dev/input/by-id/ | grep ${GAMEPAD_USB_PASSTHROUGH} | awk '{print $9}'`
   export GAMEPAD_USB_DEVICE_NAME=${GAMEPAD_USB_DEVICE_NAME/-joystick/}
   export GAMEPAD_USB_EVENT=`ls -lah /dev/input/by-id/ | grep $GAMEPAD_USB_DEVICE_NAME | grep event | awk '{print $11}'`
   export GAMEPAD_USB_EVENT=${GAMEPAD_USB_EVENT/..\//}
}

# Get nvidia driver version
nvidia_setup() {
   export NVIDIA_VER=$(head -n1 </proc/driver/nvidia/version | awk '{ print $8 }')
}

# Get uid and gid
uid_gid_setup() {
   export PUID=`id -u`
   export PGID=`id -g`
}

# Setup pulseaudio
audio_setup() {
   pacmd set-default-sink ${AUDIO_SINK}
   TRUE_SINK=$(pacmd list-sinks|awk '/\* index:/{ print $3 }')
   echo "True audio out sink: ${TRUE_SINK}"
   export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR}
   export AUDIO_GROUP=`getent group audio | cut -d: -f3`
}

# Setup advancedsettings.xml for use with MariaDB
db_setup() {
   mkdir -p ./volumes/kodi/.kodi/userdata
   sed 's/'"<pass>kodi<\/pass>"'/'"<pass>${MARIADB_PASS}<\/pass>"'/g' \
       < ./kodi/advancedsettings_template.xml \
       > ./volumes/kodi/.kodi/userdata/advancedsettings.xml
   sed -i 's/'"\*\*\*.\*\*\*.\*\*\*.\*\*\*"'/'"mariadb_kodi"'/g' ./volumes/kodi/.kodi/userdata/advancedsettings.xml
   cp ./kodi/playercorefactory.xml ./volumes/kodi/.kodi/userdata/playercorefactory.xml
}

# Copy add-ons
copy_addons() {
  mkdir -p ./volumes/kodi
  wget -nc -O ./volumes/kodi/repository.kodi_libretro_buildbot_game_addons.zip \
       "https://github.com/zach-morris/kodi_libretro_buildbot_game_addons/raw/master/repository.kodi_libretro_buildbot_game_addons.zip"
  wget -nc -O ./volumes/kodi/script.games.rom.collection.browser-master.zip  \
       "https://github.com/maloep/romcollectionbrowser/archive/master.zip"
  wget -nc -O ./volumes/kodi/plugin.program.advanced.emulator.launcher-master.zip \
       "https://github.com/Wintermute0110/plugin.program.AEL/archive/release-0.9.8.zip"
}

gamepad_setup
nvidia_setup
uid_gid_setup
db_setup
audio_setup
copy_addons
docker-compose build
docker-compose up



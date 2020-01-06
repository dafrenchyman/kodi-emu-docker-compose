FROM lsiobase/ubuntu:bionic
#FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

ARG NVIDIA_VER
ENV NVIDIA_VER $NVIDIA_VER

######################################################
# Install dependencies (glmark2)
######################################################
RUN apt-get update && \
    apt-get install -y \
            alsa-base \
            alsa-utils \
            binutils \
            cifs-utils \
            kmod \
            git \
            libxv1 \
            libasound2 \
            libpulse0 \
            nfs-common \
            mesa-utils \
            mesa-utils-extra \
            pulseaudio \
            smbclient \
            software-properties-common \
            tzdata \
            xdg-utils \
            xz-utils \
            x-window-system \
            wget

######################################################
# Kodi
######################################################
RUN add-apt-repository -y ppa:team-xbmc/ppa && \
    apt-get update && \
    apt-get install -y kodi \
                       kodi-screensaver-* \
                       kodi-audiodecoder-* \
                       kodi-visualization-* \
                       kodi-game-libretro \
                       kodi-game*

######################################################
# Install PPSSPP
######################################################
RUN add-apt-repository ppa:ppsspp/stable && \
    apt-get update && \
    apt-get install -y ppsspp

######################################################
# Install Retroarch
######################################################
RUN add-apt-repository ppa:libretro/stable && \
    apt-get update && \
    apt-get install -y retroarch* libretro-*

######################################################
# Install Dolphin Emulator
######################################################
RUN apt-get install -y qt5-default libx11-xcb1 && \
    apt-add-repository ppa:dolphin-emu/ppa && \
    apt-get update && \
    apt-get install -y dolphin-emu

######################################################
# Install pcsx2
######################################################
#     apt-get install -y xserver-xorg xorg jwm libgtk-3-0
#RUN dpkg --add-architecture i386 && \
#    add-apt-repository ppa:gregory-hainaut/pcsx2.official.ppa && \
#    apt-get update && \
#    apt-get install -y pcsx2

RUN dpkg --add-architecture i386 && \
    add-apt-repository ppa:pcsx2-team/pcsx2-daily && \
    apt-get update && \
    apt-get install -y libgtk-3-0 pcsx2-unstable

######################################################
# Install Nvidia Drivers
######################################################
RUN wget -O /tmp/nvidia.run \
        https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_VER}/NVIDIA-Linux-x86_64-${NVIDIA_VER}.run && \
    chmod +x /tmp/nvidia.run && \
    /tmp/nvidia.run --accept-license \
                    --no-runlevel-check \
                    --no-questions \
                    --ui=none \
                    --no-kernel-module \
                    --no-kernel-module-source \
                    --no-backup \
                    --tmpdir /tmp2

######################################################
# Fix permissions
######################################################

#COPY root/ /


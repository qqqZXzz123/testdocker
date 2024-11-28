FROM debian:stable-slim
    
ARG DEBIAN_FRONTEND=noninteractive





RUN apt-get update \
    && apt-get install -y \
    wget \
    nano \
    curl \
    unzip \
    zip \
    libstdc++6 \
    tzdata \
    ca-certificates \
    locales \
    git \
    sudo
RUN useradd -d /home/container -m container && \
    echo container:container | chpasswd && \
    cp /etc/sudoers /etc/sudoers.bak && \
    echo 'container  ALL=(root) NOPASSWD: ALL' >> /etc/sudoers
RUN echo 'root:root' | chpasswd

RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update -y
RUN apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0 


RUN locale-gen ru_RU.UTF-8
ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU:ru
ENV LC_ALL ru_RU.UTF-8

ENV TERM=xterm

#timezone fix
ENV TZ=Europe/Moscow
RUN ln -fs /usr/share/zoneinfo/US/Pacific-New /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]

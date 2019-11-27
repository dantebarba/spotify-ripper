FROM ubuntu:xenial

RUN mkdir /ripper && mkdir /ripper/source-code

RUN apt update
RUN apt upgrade -y

RUN apt install software-properties-common python-software-properties zsh -y --no-install-recommends
RUN apt-add-repository multiverse -y
RUN apt update -y

RUN apt install build-essential automake autoconf wget -y --no-install-recommends
RUN apt install lame libffi-dev -y --no-install-recommends

#libssl-dev flac libav-tools faac libfdk-aac-dev vorbis-tools opus-tools \
#        -y --no-install-recommends

RUN apt install python-dev python-pip -y --no-install-recommends

ENV PYTHONIOENCODING utf-8

RUN apt-get update && apt-get -y install locales
RUN locale-gen en_GB.UTF-8
ENV LANG='en_GB.UTF-8' LANGUAGE='en_GB:en' LC_ALL='en_GB.UTF-8'


#RUN wget https://github.com/nu774/fdkaac/archive/v0.6.2.tar.gz && tar xvf v0.6.2.tar.gz
#RUN cd fdkaac-0.6.2 && autoreconf -i && ./configure && make install

# Install libspotify
RUN wget https://github.com/mopidy/libspotify-archive/raw/master/libspotify-12.1.51-Linux-x86_64-release.tar.gz && tar xvf libspotify-12.1.51-Linux-x86_64-release.tar.gz
RUN cd libspotify-12.1.51-Linux-x86_64-release/ && make install prefix=/usr/local

WORKDIR /ripper/source-code
RUN pip install setuptools wheel
COPY requirements.txt /ripper/source-code
RUN pip install -r requirements.txt

COPY spotify_ripper /ripper/source-code/spotify_ripper
COPY setup.py /ripper/source-code/
COPY README.rst /ripper/source-code/
#COPY docker_config/* /ripper/source-code/
RUN pip install .

ENV user=
ENV pass=
ENV playlist=

ENV SPOTIPY_CLIENT_SECRET=
ENV SPOTIPY_CLIENT_SECRET=

VOLUME /config
VOLUME /music

WORKDIR /root/workdir

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT bash /entrypoint.sh
#ENTRYPOINT zsh

FROM phusion/baseimage

ADD . /u16

RUN /u16/install_only_go.sh && rm -rf /tmp && mkdir /tmp



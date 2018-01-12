# DOCKER-VERSION 0.3.4
FROM        perl:latest
MAINTAINER  Thomas Carlier tcarlier@gmail.com

RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm Carton

RUN git clone https://github.com/tcarlier/blowfish.git

RUN cd blowfish/blowfish & ls

RUN ls

RUN carton install

# EXPOSE 8080

WORKDIR blowfish
CMD carton exec bin/blowfish.pl abcdefgh

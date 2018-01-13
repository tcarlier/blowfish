# DOCKER-VERSION 0.3.4
FROM        perl:latest
MAINTAINER  Thomas Carlier tcarlier@gmail.com

RUN echo curl
RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN cpanm Carton

COPY ./blowfish blowfish

WORKDIR blowfish

RUN carton install

ENV PATH=./bin:$PATH

ENTRYPOINT [ "carton", "exec", "perl", "bin/blowfish.pl" ]

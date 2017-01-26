FROM ubuntu
MAINTAINER mohan "mohan@extrasalt.org"

RUN apt-get -y -qq --force-yes update \
    && apt-get -y -qq --force-yes install \
        vim git sudo curl tmux

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen --purge --lang en_US \
    && locale-gen

ENV LANG en_US.utf8

RUN groupadd -g 999 docker \
    && useradd \
        -G sudo,docker \
        -d /home/app \
        -m \
        -p $(openssl passwd 123app4) \
        -s $(which bash) \
        app

USER app

ENV HOME /home/app

ENV GOROOT ${HOME}/go
ENV GOPATH ${HOME}/go
ENV GOBIN ${GOPATH}/bin
ENV GO_VERSION 1.7.4
ENV GO_FILENAME go${GO_VERSION}.linux-amd64
ENV GO_TARNAME ${GO_FILENAME}.tar.gz
ENV GO_URL https://storage.googleapis.com/golang/${GO_TARNAME}
WORKDIR /home/app
RUN curl -o go.tar.gz ${GO_URL}
RUN tar -C ${HOME} -xzf go.tar.gz
ENV PATH ${PATH}:${GOBIN}
RUN rm go.tar.gz
RUN mkdir -p ${HOME}/code
ENV GOPATH ${HOME}/code
ENV TERM xterm-256color
CMD ["/usr/bin/bash"]

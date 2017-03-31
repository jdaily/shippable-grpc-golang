FROM ubuntu:16.04
ADD . /u16

RUN /u16/install_only_go.sh && rm -rf /tmp && mkdir /tmp

# Install protobuf
ENV PB_VER 3.2.0
ENV GOPATH $HOME/go
ENV PB_URL https://github.com/google/protobuf/releases/download/v${PB_VER}/protoc-${PB_VER}-linux-x86_64.zip
RUN curl -L ${PB_URL} > /tmp/protoc.zip && \
    cd /tmp && \
    unzip protoc.zip -d /usr/local && \
    chmod go+rx /usr/local/bin/protoc && \
    cd /tmp && \
    rm -r /tmp/protoc.zip

RUN ["/bin/bash", "-c", "go get google.golang.org/grpc && go get -u github.com/tools/godep"]
RUN ["/bin/bash", "-c", "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"]
RUN ["/bin/bash", "-c", "go get -u github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger"]
RUN ["/bin/bash", "-c", "go get -u github.com/golang/protobuf/protoc-gen-go"]

RUN add-apt-repository ppa:masterminds/glide && sudo apt-get update
RUN apt-get install -y glide --allow-unauthenticated

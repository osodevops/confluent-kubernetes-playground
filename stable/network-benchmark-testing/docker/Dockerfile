ARG GOLANG_VERSION=1.18
FROM golang:${GOLANG_VERSION} as builder
WORKDIR /workspace

COPY nptests/nptest.go nptest.go
COPY go.sum go.sum
COPY go.mod go.mod

RUN go build -o nptests

FROM debian:jessie
ENV LD_LIBRARY_PATH=/usr/local/lib

# install binary and remove cache
RUN apt-get update \
    && apt-get install -y  curl wget net-tools gcc make libsctp-dev \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /tmp


# Download and build iperf3 from sources
RUN curl -LO https://downloads.es.net/pub/iperf/iperf-3.1.tar.gz && tar zxf iperf-3.1.tar.gz
RUN cd iperf-3.1 && ./configure --prefix=/usr/local --bindir /usr/local/bin && make && make install

# Download and build netperf from sources
RUN curl -LO https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz && tar -xzf netperf-2.7.0.tar.gz && mv netperf-netperf-2.7.0/ netperf-2.7.0
RUN cd netperf-2.7.0 && ./configure --prefix=/usr/local --bindir /usr/local/bin && make && make install

COPY --from=builder /workspace/nptests /usr/bin/

ENTRYPOINT ["nptests"]
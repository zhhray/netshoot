FROM alpine:3.11

RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && sed -i 's/nl.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    # sys:
    bash \
    vim \
    curl \
    sudo \
    runuser \
    jq \
    py-crypto \
    openssl \
    openssh-client \
    busybox-extras \
    util-linux \
    libc6-compat \
    tmux \
    # net:
    net-tools \
    apache2-utils \
    bind-tools \
    bird \
    bridge-utils \
    conntrack-tools \
    dhcping \
    drill \
    ethtool \
    fping \
    httpie \
    iperf \
    iptraf-ng \
    iputils \
    liboping \
    mtr \
    net-snmp-tools \
    netcat-openbsd \
    nftables \
    ngrep \
    nmap \
    nmap-nping \
    scapy \
    socat \
    tcptraceroute \
    websocat \
    tcpdump \
    iproute2 \
    tshark \
    iftop \
    ipvsadm \
    ipset \
    strace \
    iptables \
    hping3 \
    # fs
    sysstat \
    file \
    fio

# apparmor issue #14140
RUN mv /usr/sbin/tcpdump /usr/bin/tcpdump

RUN adduser -D -u 10000 debugger

USER debugger

# Installing ctop - top-like container monitor
#COPY --from=fetcher /tmp/ctop /usr/local/bin/ctop
COPY build/ctop /usr/local/bin/ctop

# Installing calicoctl
#COPY --from=fetcher /tmp/calicoctl /usr/local/bin/calicoctl
COPY build/calicoctl /usr/local/bin/calicoctl

# Installing termshark
#COPY --from=fetcher /tmp/termshark /usr/local/bin/termshark
COPY build/termshark /usr/local/bin/termshark

# Settings
ADD motd /etc/motd
ADD profile  /etc/profile

CMD ["/bin/bash","-l"]

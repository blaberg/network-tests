FROM balenalib/intel-nuc-debian:latest

RUN set -xe \
    && apt-get update \
    && apt-get install strongswan \
    && apt-get install -y iperf3 \
    && apt-get install sockperf \
    && apt-get install python3 \
    && apt-get install tcpdump \
    && apt-get install -y python3-pip \
    && apt-get install sysstat \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install psrecord matplotlib tk

COPY setup.sh /setup.sh
RUN chmod 0755 /setup.sh

COPY test.sh /test.sh
RUN chmod 0755 /test.sh

COPY sar.sh /
RUN chmod 0755 /sar.sh

COPY ipsec.conf /etc/ipsec.conf

COPY ipsec.secrets /etc/ipsec.secrets
RUN chmod 0600 /etc/ipsec.secrets

ENTRYPOINT ["/setup.sh"]

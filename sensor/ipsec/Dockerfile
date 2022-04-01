FROM balenalib/intel-nuc-debian:latest

RUN set -xe \
    && apt-get update \
    && apt-get install strongswan \
    && apt-get install sockperf \
    && apt-get install -y iperf3 \
    && rm -rf /var/lib/apt/lists/*


COPY run.sh /run.sh
RUN chmod 0755 /run.sh

COPY ipsec.conf /etc/ipsec.conf

COPY ipsec.secrets /etc/ipsec.secrets
RUN chmod 0600 /etc/ipsec.secrets

EXPOSE 500/udp 4500/udp 5201

ENTRYPOINT ["/run.sh"]

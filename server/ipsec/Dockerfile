FROM balenalib/intel-nuc-debian:latest

RUN set -xe \
    && apt-get update \
    && apt-get install strongswan \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y iperf3 \
    && rm -rf /var/lib/apt/lists/*


COPY run.sh /run.sh
RUN chmod 0755 /run.sh

COPY ipsec.conf /etc/ipsec.conf

COPY ipsec.secrets /etc/ipsec.secrets
RUN chmod 0600 /etc/ipsec.secrets

ENTRYPOINT ["/run.sh"]

FROM balenalib/intel-nuc-debian:latest

RUN set -xe \
    && apt-get update \
    && apt-get install strongswan \
    && apt-get install sockperf \
    && apt-get install -y iperf3 \
    && rm -rf /var/lib/apt/lists/*


COPY setup.sh /setup.sh
RUN chmod 0755 /setup.sh

COPY test.sh /test.sh
RUN chmod 0755 /test.sh

#COPY ipsec.conf /etc/ipsec.conf

#COPY ipsec.secrets /etc/ipsec.secrets
#RUN chmod 0600 /etc/ipsec.secrets

EXPOSE 500/udp 4500/udp 5201

ENTRYPOINT ["/setup.sh"]


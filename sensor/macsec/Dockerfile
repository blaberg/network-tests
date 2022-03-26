FROM balenalib/intel-nuc-debian:latest

RUN apt-get update \
    && apt-get install -y iperf3 \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /app/run.sh
RUN chmod 0755 /app/run.sh

WORKDIR /app
CMD [ "./run.sh"]

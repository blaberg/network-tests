FROM balenalib/intel-nuc-debian:latest

RUN apt-get update \
    && apt-get install -y iperf3 \
    && apt-get install python3 \
    && apt-get install -y python3-pip \
    && apt-get install sockperf \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install psrecord matplotlib tk

COPY run.sh /app/run.sh
RUN chmod 0755 /app/run.sh

WORKDIR /app
CMD [ "./run.sh"]

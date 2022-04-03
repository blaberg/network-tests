FROM balenalib/intel-nuc-debian:latest

RUN apt-get update \
    && apt-get install -y iperf3 \
    && apt-get install python3 \
    && apt-get install -y python3-pip \
    && apt-get install sockperf \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install psrecord matplotlib tk

COPY setup.sh /app/setup.sh
RUN chmod 0755 /app/setup.sh

COPY test.sh /app/test.sh
RUN chmod 0755 /app/test.sh

WORKDIR /app

CMD [ "sleep", "infinity"]

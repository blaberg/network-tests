
FROM balenalib/intel-nuc-debian:latest
# install binary and remove cache
RUN apt-get update \
    && apt-get install -y iperf3 \
    && apt-get install sockperf \
    && apt-get install python3 \
    && apt-get install sysstat \
    && apt-get install -y python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install psrecord matplotlib tk

# Expose the default iperf3 server port
EXPOSE 5201

COPY run.sh /
RUN chmod 0755 /run.sh

COPY sar.sh /
RUN chmod 0755 /sar.sh


#CMD [ "./run.sh"]
CMD ["sleep", "infinity"]

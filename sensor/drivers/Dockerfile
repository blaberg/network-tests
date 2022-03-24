FROM balenalib/intel-nuc-debian:stretch AS builder

RUN \
    # Kernel module build dependencies
    apt-get update \
    && apt-get install -y --no-install-recommends \
    bc=1.06.95-9+b3 \
    build-essential=12.3 \
    flex=2.6.1-1.3 \
    bison=2:3.0.4.dfsg-1+b1 \
    autoconf=2.69-10 \
    libssl-dev=1.1.0l-1* \
    libelf-dev=0.168-1* \
    wget=1.18-5+deb9u3 \
    && rm -rf /var/lib/apt/lists/*

COPY build_balena_modules.sh /app/
WORKDIR /app

# Build CAN modules for each balena device and release
RUN ./build_balena_modules.sh "intel-nuc" "2.68.1+rev1"

FROM alpine:3.11

COPY --from=builder /modules /modules
COPY run.sh /app/run.sh
RUN chmod 0755 /app/run.sh

WORKDIR /app
CMD [ "./run.sh", "/modules" ]

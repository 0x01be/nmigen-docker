FROM 0x01be/yosys as yosys
FROM 0x01be/icestorm as icestorm
FROM 0x01be/nextpnr:ice40 as nextpnr

FROM alpine as build

RUN apk add --no-cache --virtual nmigen-build-dependencies \
    git \
    py3-pip &&\
    pip install --prefix=/opt/nmigen \
    git+https://github.com/m-labs/nmigen.git \
    git+https://github.com/m-labs/nmigen-boards.git

FROM alpine

RUN apk add --no-cache --virtual nmigen-runtime-dependencies \
    python3

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=icestorm /opt/icestorm/ /opt/icestorm/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/
COPY --from=build /opt/nmigen/ /opt/nmigen/

ENV USER=nmigen \
    WORKSPACE=/workspace
RUN adduser -D -u 1000 ${USER} &&\
    mkdir -p ${WORKSPACE} &&\
    chown ${USER}:${USER} ${WORKSPACE}

USER ${USER}
WORKDIR ${WORKSPACE}
ENV PATH=${PATH}:/opt/yosys/bin/:/opt/icestorm/bin/:/opt/nextpnr/bin/ \
    PYTHONPATH=/usr/lib/python3.8/site-packages/:/opt/nmigen/lib/python3.8/site-packages/


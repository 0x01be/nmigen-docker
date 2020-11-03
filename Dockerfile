FROM 0x01be/yosys as yosys
FROM 0x01be/prjtrellis as prjtrellis
FROM 0x01be/nextpnr:ecp5 as nextpnr

FROM alpine as build

RUN apk add --no-cache --virtual nextpnr-build-dependencies \
    git \
    py3-pip &&\
    pip install --prefix=/opt/nmigen/ \
    git+https://github.com/m-labs/nmigen.git \
    git+https://github.com/m-labs/nmigen-boards.git

FROM alpine

RUN apk add --no-cache --virtual nextpnr-runtime-dependencies \
    python3

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=prjtrellis /opt/prjtrellis/ /opt/prjtrellis/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/
COPY --from=build /opt/nmigen/ /opt/nmigen/

ENV USER=nmigen \
    WORKSPACE=/workspace
RUN adduser -D -u 1000 ${USER}  && mkdir ${WORKSPACE} && chown ${USER}:${USER}

USER ${USER}

ENV PATH=${PATH}:/opt/yosys/bin/:/opt/prjtrellis/bin/:/opt/nextpnr/bin/ \
    PYTHONPATH=/usr/lib/python3.8/site-packages/:/opt/nmigen/lib/python3.8/site-packages/


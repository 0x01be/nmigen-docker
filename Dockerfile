FROM 0x01be/yosys as yosys
FROM 0x01be/icestorm as icestorm
FROM 0x01be/nextpnr:ice40 as nextpnr

FROM 0x01be/alpine:edge as builder

RUN apk add --no-cache --virtual nmigen-build-dependencies \
    git \
    py3-pip

RUN pip install git+https://github.com/m-labs/nmigen.git
RUN pip install git+https://github.com/m-labs/nmigen-boards.git

FROM 0x01be/alpine:edge

RUN apk add --no-cache --virtual nmigen-runtime-dependencies \
    python3

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=icestorm /opt/icestorm/ /opt/icestorm/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/
COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/

ENV PATH /opt/yosys/bin/:/opt/icestorm/bin/:/opt/nextpnr/bin/:$PATH


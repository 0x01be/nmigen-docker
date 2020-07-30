FROM 0x01be/yosys as yosys
FROM 0x01be/prjtrellis as prjtrellis
FROM 0x01be/nextpnr:ecp5 as nextpnr

FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    git \
    py3-pip

RUN pip install git+https://github.com/m-labs/nmigen.git
RUN pip install git+https://github.com/m-labs/nmigen-boards.git

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    python3

COPY --from=yosys /opt/yosys/ /opt/yosys/
COPY --from=prjtrellis /opt/prjtrellis/ /opt/prjtrellis/
COPY --from=nextpnr /opt/nextpnr/ /opt/nextpnr/
COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/

ENV PATH /opt/yosys/bin/:/opt/prjtrellis/bin/:/opt/nextpnr/bin/:$PATH


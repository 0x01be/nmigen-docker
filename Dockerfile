FROM 0x01be/yosys as yosys

FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    py3-pip

RUN pip install git+https://github.com/m-labs/nmigen.git
RUN pip install git+https://github.com/m-labs/nmigen-boards.git
RUN pip install git+https://github.com/m-labs/nmigen-stdio.git
RUN pip install git+https://github.com/m-labs/nmigen-soc.git

FROM alpine:3.12.0

RUN apk add --no-cache --virtual runtime-dependencies \
    python3

COPY --from=builder /usr/lib/python3.8/site-packages/ /usr/lib/python3.8/site-packages/
COPY --from=yosys /opt/yosys/ /opt/yosys/

ENV PATH /opt/yosys/bin/:$PATH


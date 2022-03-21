FROM alpine:3.12

WORKDIR /app

RUN apk add --update --no-cache --virtual .build-deps git make cmake libstdc++ gcc g++ automake libtool autoconf linux-headers \
    && git clone https://github.com/xmrig/xmrig.git /tmp/xmrig \
    && mkdir /tmp/xmrig/build

RUN sed -i 's/kDefaultDonateLevel = 1/kDefaultDonateLevel = 0/' /tmp/xmrig/src/donate.h

RUN cd /tmp/xmrig/scripts && ./build_deps.sh
RUN cmake -S /tmp/xmrig -B /tmp/xmrig/build -DXMRIG_DEPS=/tmp/xmrig/scripts/deps -DBUILD_STATIC=ON
RUN make -j$(nproc) -C /tmp/xmrig/build
RUN mv /tmp/xmrig/build/xmrig /usr/sbin/ 
RUN apk del .build-deps 
RUN rm -rf /tmp/*

RUN apk add cpulimit

ADD config.json /app/config.json
ADD entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]

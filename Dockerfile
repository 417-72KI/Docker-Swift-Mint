ARG SWIFT_VERSION=5.10
FROM swift:${SWIFT_VERSION}-focal

LABEL maintainer "417-72KI <417.72ki@gmail.com>"

ARG MINT_REVISION=master
ENV MINT_REVISION=${MINT_REVISION}

ENV MINT_LINK_PATH="/usr/local/bin"

# Install Mint
RUN git clone -b "${MINT_REVISION}" --depth 1 "https://github.com/yonaskolb/Mint.git" ~/Mint && \
    cd ~/Mint && \
    git rev-parse HEAD > /.mint_revision && \
    swift build --disable-sandbox -c release && \
    mkdir -p /usr/local/bin && \
    cp -f .build/release/mint /usr/local/bin/mint && \
    cd && \
    rm -rf ~/Mint

CMD [ "/bin/bash" ]

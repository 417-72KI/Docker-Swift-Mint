ARG SWIFT_VERSION=latest
FROM swift:${SWIFT_VERSION}

LABEL maintainer "417-72KI <417.72ki@gmail.com>"

ARG MINT_REVISION=master
ENV MINT_REVISION=${MINT_REVISION}

# Install Mint
RUN git clone -b "${MINT_REVISION}" --depth 1 "https://github.com/yonaskolb/Mint.git" ~/Mint && \
    cd ~/Mint && \
    swift build --disable-sandbox -c release && \
    cd && \
    rm -rf ~/Mint

CMD [ "/bin/bash" ]

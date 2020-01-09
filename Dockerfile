FROM swift:5.1

LABEL maintainer "417-72KI <417.72ki@gmail.com>"

ENV MINT_REVISION=master

# Install Mint
RUN git clone -b ${MINT_REVISION} --depth 1 https://github.com/yonaskolb/Mint.git ~/Mint && \
    make -C ~/Mint && \
    rm -rf ~/Mint

RUN mint version

ENTRYPOINT [ "/bin/bash" ]

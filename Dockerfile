FROM swift:5.1

ENV MINT_VERSION=master

RUN git clone -b ${MINT_VERSION} --depth 1 https://github.com/yonaskolb/Mint.git ~/Mint && \
    make -C ~/Mint && \
    rm -rf ~/Mint

ENTRYPOINT [ "/bin/bash" ]

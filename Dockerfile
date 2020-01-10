FROM swift:5.1

LABEL maintainer "417-72KI <417.72ki@gmail.com>"

ARG MINT_REVISION=master
ENV MINT_REVISION=${MINT_REVISION}

# Install Mint
RUN git clone -b ${MINT_REVISION} --depth 1 https://github.com/yonaskolb/Mint.git ~/Mint && \
    make -C ~/Mint && \
    rm -rf ~/Mint

CMD [ "/bin/bash" ]

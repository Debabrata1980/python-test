FROM alpine:3.16

# Update package repo indexes
RUN apk -q update

# Update packages
RUN apk -q upgrade

# Install linux libraries needed for common c360 python unit tests
RUN apk -q add python3 py3-pip openssl libressl-dev rust cargo
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install python flake8 for liniting
RUN pip3 install flake8 pytest

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]

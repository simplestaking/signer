FROM python:3.6.8-alpine

# Needed for pycurl
ENV PYCURL_SSL_LIBRARY=openssl

RUN \
    apk add --no-cache \
        python3-dev \
        py3-setuptools \
        cython \
        eudev-dev \
        libusb-dev \
        curl \
        unzip \
        git \
        libffi-dev \
        build-base \
        openssl-dev \
        zlib-dev \
        jpeg \
        py3-pillow \
        protobuf \
        protobuf-dev \
        libcurl \
        curl-dev


COPY requirements.txt /
RUN pip3 install -r requirements.txt

RUN git clone https://github.com/simplestaking/trezor-common.git --branch staking_message
RUN git clone https://github.com/simplestaking/python-trezor.git --branch staking
# copy trezor-common with trezor proto messages  for staking
RUN cp -r trezor-common python-trezor/vendor/

# setup python trezor
RUN cd python-trezor && python setup.py develop

# development stage, replace with git repo later
COPY signer/. /signer/
COPY app.py /
COPY tests/. /tests/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 5000

# CMD ["./entrypoint.sh"]

# ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:5000", "-w", "4", "app:api"]
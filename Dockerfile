#
# Dockerfile to create container with modified mosquitto broker executable.
#

FROM debian:stretch

LABEL Maintainer="f.sieber@hiconnect.de"
LABEL Description="This image is used to start a modified mosquitto executable with HICAP interface. It logs all incoming MQTT publish messages and their connection metadata to a remote logstash service for further processing."

# Install libraries required by modified mosquitto executable.
# File libuuid.so is already present in Debian Stretch.
RUN apt-get update && apt-get install -y \
    libssl1.1 \
    libuv1 \
    libjansson4 \
    python-pip && \
    pip install j2cli

RUN mkdir /mosquitto
RUN useradd --no-create-home --shell /usr/sbin/nologin --user-group mosquitto

COPY docker-entrypoint.sh mosquitto mosquitto_passwd /mosquitto/
#mosquitto.conf pwd
COPY /templates/ /templates/

RUN chown -R mosquitto:mosquitto /mosquitto
RUN chmod +x /mosquitto/mosquitto /mosquitto/docker-entrypoint.sh

CMD [ "/mosquitto/mosquitto", "-c", "/mosquitto/mosquitto.conf" ]
#CMD [ "mosquitto", "-c", "/mosquitto/config/mosquitto.conf"]

ENTRYPOINT [ "/mosquitto/docker-entrypoint.sh" ]

# TCP/IP port 1883 is reserved by IANA for use with MQTT.
# TCP/IP port 8883 is also registered, for using MQTT over SSL.
# TCP/IP port 443 is for HTTPS and thus usually open in any firewall.
# Note: Only the port configured in /mosquitto/mosquitto.conf is served.
EXPOSE 443/tcp 1883 8883

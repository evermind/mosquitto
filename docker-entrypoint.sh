#!/bin/bash

set -x

#
# env vars HICAP_HOST and HICAP_PORT are normally set during container creation time:
#
# $ docker create   -i -t -e "HICAP_HOST=127.0.0.1" -e "HICAP_PORT=5555" ...
# $ docker run --rm -i -t -e "HICAP_HOST=127.0.0.1" -e "HICAP_PORT=5555" ...
#

#
# to override env vars provided by user via docker
#
#HICAP_HOST=127.0.0.1
#HICAP_PORT=5555

#
# to apply defaults in case of user does not provide env vars via docker
#
export HICAP_HOST=${HICAP_HOST:-127.0.0.1}
export HICAP_PORT=${HICAP_PORT:-5555}

j2 /templates/mosquitto.conf > /mosquitto/mosquitto.conf
j2 /templates/pwd > /mosquitto/pwd

exec "$@"

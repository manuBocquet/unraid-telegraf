#!/bin/bash
set -e

TELEGRAF_CONFIG_PATH=/config/etc/telegraf.conf
export TELEGRAF_CONFIG_PATH

if [ ! -d "/config/log" ]; then
	mkdir /config/log
fi

if [ ! -d "/config/etc" ]; then
	mkdir /config/etc
fi

env > /config/log/env.log

if [ ! -f "${TELEGRAF_CONFIG_PATH}" ]; then
	telegraf --input-filter cpu:mem:net:docker --output-filter influxdb:telegraf config > ${TELEGRAF_CONFIG_PATH}.orig
	cat ${TELEGRAF_CONFIG_PATH}.orig | grep -v "^\s*#" | sed '/^\s*$/d' > ${TELEGRAF_CONFIG_PATH}
fi

if [ -n "${INFLUX_DB}" ]; then
	sed -i '/^\s*urls/c\  urls = ["http://'"${INFLUX_DB}"'"] # upd endpoint'  ${TELEGRAF_CONFIG_PATH}
fi

if [ -n "${MyHOSTNAME}" ]; then
	sed -i '/^\s*hostname/c\  hostname = "'"${MyHOSTNAME}"'" ' ${TELEGRAF_CONFIG_PATH}
fi

if [ -n "${LOGFILE}" ]; then
	sed -i '/^\s*logfile/c\  logfile = "'"${LOGFILE}"'" ' ${TELEGRAF_CONFIG_PATH}
fi

if [ "${1:0:1}" = '-' ]; then
    set -- telegraf "$@"
fi

exec "$@"

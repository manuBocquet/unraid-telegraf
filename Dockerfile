FROM telegraf:latest

EXPOSE 8125/udp 8092/udp 8094
VOLUME [ "/config" ]

ENV HOST_PROC="/rootfs/proc"
ENV HOST_SYS="/rootfs/sys"
ENV HOST_ETC="/rootfs/etc"

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]


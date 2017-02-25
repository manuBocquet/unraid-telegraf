FROM telegraf:1.1.2

EXPOSE 8125/udp 8092/udp 8094
VOLUME [ "/config" ]

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]


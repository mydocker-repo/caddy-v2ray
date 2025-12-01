FROM docker.io/library/caddy:2.10.2
RUN apk add --no-cache tzdata curl v2ray
WORKDIR /root
RUN echo "Asia/Shanghai" > /etc/timezone
RUN echo "alias ll='ls -la'" > /root/.bashrc && \
    echo "PS1='\[\e[1;32m\][\W]\$\[\e[0m\] '" >> /root/.bashrc
    
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# 最终命令：启动 cron 并给 shell
ENTRYPOINT ["/entrypoint.sh"]
CMD ["caddy && v2ray run"]

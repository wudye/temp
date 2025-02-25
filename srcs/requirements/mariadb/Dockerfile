FROM debian:bookworm-slim


RUN	apt-get update 
RUN	apt-get install -y mariadb-server mariadb-client

COPY ./conf/my.cnf /etc/mysql/my.cnf
RUN chmod +x /etc/mysql/my.cnf

COPY ./tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]

# Command launched at the end of the setup
CMD ["/usr/bin/mysqld_safe", "--datadir=/var/lib/mysql"]
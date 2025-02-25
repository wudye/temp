#!/bin/sh


mkdir -p /run/mysqld /var/lib/mysql /var/log/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql /var/log/mysql
chmod +x /var/log/mysql/

mysql_install_db --user=mysql --datadir=/var/lib/mysql --auth-root-authentication-method=normal --skip-test-db


DATABASE_DIR="/var/lib/mysql/${MYSQL_DATABASE}"

if [ ! -d "$DATABASE_DIR" ]; then

    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
    mysqld --datadir=/var/lib/mysql --user=mysql &

    # Give MySQL some time to start
    sleep 2

    # Trap any error and ensure MySQL server is stopped    
    trap 'echo "Error: MySQL commands failed." >&2; killall mysqld 2> /dev/null; exit 1' ERR


    mysql -u root <<EOF
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        
        DELETE FROM mysql.user WHERE user='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DELETE FROM mysql.user WHERE user='';
        
        CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        
        FLUSH PRIVILEGES;
EOF
    # Remove the trap after successful execution
    trap - ERR
    killall mysqld 2> /dev/null
fi


exec "$@"
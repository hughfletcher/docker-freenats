FROM purplepixie/freenats:latest

RUN mkdir /tmp/nats-upgrade && \
    cd /tmp/nats-upgrade && \
    wget --trust-server-names http://www.purplepixie.org/freenats/downloads/freenats-1.20.1b.tar.gz && \
    tar -xvzf freenats-1.20.1b.tar.gz && \
    cd freenats-1.20.1b && \
    /bin/mv server/web/firstrun.php server/web/firstrun-.php && \
    /bin/mv server/web/include.php server/web/include-.php && \
    /bin/mv server/bin/include.php server/bin/include-.php && \
    /bin/mv server/base/config.inc.php server/base/config-.inc.php && \
    /bin/cp -Rf -v server/base/* /opt/freenats/server/base/ && \
    /bin/cp -Rf -v server/web/* /srv/www/html && \
    /bin/cp -Rf -v server/bin/* /opt/freenats/server/bin/ \
    && service mysqld restart \
    && mysql -u root freenats < server/base/sql/schema.drop.sql \
    && mysql -u root freenats < server/base/sql/default.sql \
    && mysql -u root freenats < server/base/sql/example.sql

# Expose mysql for backup purposes
EXPOSE 3306

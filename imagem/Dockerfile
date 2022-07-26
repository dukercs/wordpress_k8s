FROM wordpress:apache
ADD --chown=www-data:www-data .htaccess /var/www/html/.htaccess
ADD --chown=www-data:www-data .htaccess /usr/src/wordpress/.htaccess
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD exportadores.sh /usr/local/bin/exportadores.sh

RUN sed -i '/exec apache2 -DFOREGROUND/i exec /usr/local/bin/exportadores.sh \&' /usr/local/bin/apache2-foreground \
    && chmod a+x /usr/local/bin/exportadores.sh \
    && apt-get update > /dev/null 2>&1 \
    && apt-get install -y --no-install-recommends netcat > /dev/null 2>&1 \
    && curl -s https://api.github.com/repos/Lusitaniae/apache_exporter/releases/latest|grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|xargs curl -fsSL -O \
    && filename=$(curl -s https://api.github.com/repos/Lusitaniae/apache_exporter/releases/latest|grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|rev|cut -d'/' -f 1 | rev) \
    && dir=${filename%%.tar.gz} \
    && mkdir -p /usr/local/bin/ \
    && tar xzf $filename \
    && chmod a+x $dir/apache_exporter \
    && cp $dir/apache_exporter /usr/local/bin/ \
    && curl -s https://api.github.com/repos/prometheus/mysqld_exporter/releases/latest|grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|xargs curl -fsSL -O \
    && mysqlexparq=$(curl -s https://api.github.com/repos/prometheus/mysqld_exporter/releases/latest|grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|rev|cut -d'/' -f 1 | rev) \
    && mysqlexpdir=${mysqlexparq%%.tar.gz} \
    && mkdir -p /usr/local/bin/ \
    && tar xzf $mysqlexparq \
    && chmod a+x $mysqlexpdir/mysqld_exporter \
    && cp $mysqlexpdir/mysqld_exporter /usr/local/bin/ \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80/tcp
EXPOSE 9117/tcp
EXPOSE 9104/tcp

# set the base image first
FROM warrantgroup/centos:7

# specify maintainer
MAINTAINER Andy Roberts <andy.roberts@warrant-group.com>

# Install PHP and Apache httpd
RUN yum --setopt=tsflags=nodocs -y install \
    curl \
    git \	
    httpd \
    php \
    php-cli \
    php-curl \
    php-mysql \
    php-xml \
    php-pear \	
    php-pecl-apc \
    && rm -rf /var/cache/yum/* \
    && yum clean all

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer    

#
# Global Apache configuration changes
#
RUN sed -i \
    -e 's~^ServerSignature On$~ServerSignature Off~g' \
    -e 's~^ServerTokens OS$~ServerTokens Prod~g' \
    -e 's~^#ExtendedStatus On$~ExtendedStatus On~g' \
    -e 's~^DirectoryIndex \(.*\)$~DirectoryIndex \1 index.php~g' \
    -e 's~^NameVirtualHost \(.*\)$~#NameVirtualHost \1~g' \
    /etc/httpd/conf/httpd.conf

#
# Global PHP configuration changes
#
RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = Europe/London~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    /etc/php.ini

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
ADD site/ /var/www/html

EXPOSE 80
CMD ["/run.sh"]

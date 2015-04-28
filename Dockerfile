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
    php -pear \	
    php-pecl-apc \
    && rm -rf /var/cache/yum/* \
    && yum clean all

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
# Disable Apache directory indexes
#
RUN sed -i \
    -e 's~^IndexOptions \(.*\)$~#IndexOptions \1~g' \
    -e 's~^IndexIgnore \(.*\)$~#IndexIgnore \1~g' \
    -e 's~^AddIconByEncoding \(.*\)$~#AddIconByEncoding \1~g' \
    -e 's~^AddIconByType \(.*\)$~#AddIconByType \1~g' \
    -e 's~^AddIcon \(.*\)$~#AddIcon \1~g' \
    -e 's~^DefaultIcon \(.*\)$~#DefaultIcon \1~g' \
    -e 's~^ReadmeName \(.*\)$~#ReadmeName \1~g' \
    -e 's~^HeaderName \(.*\)$~#HeaderName \1~g' \
    /etc/httpd/conf/httpd.conf

#
# Disable Apache language based content negotiation
#
RUN sed -i \
    -e 's~^LanguagePriority \(.*\)$~#LanguagePriority \1~g' \
    -e 's~^ForceLanguagePriority \(.*\)$~#ForceLanguagePriority \1~g' \
    -e 's~^AddLanguage \(.*\)$~#AddLanguage \1~g' \
    /etc/httpd/conf/httpd.conf

#
# Disable all Apache modules and enable the minimum
#
RUN sed -i \
    -e 's~^\(LoadModule .*\)$~#\1~g' \
    -e 's~^#LoadModule mime_module ~LoadModule mime_module ~g' \
    -e 's~^#LoadModule log_config_module ~LoadModule log_config_module ~g' \
    -e 's~^#LoadModule setenvif_module ~LoadModule setenvif_module ~g' \
    -e 's~^#LoadModule status_module ~LoadModule status_module ~g' \
    -e 's~^#LoadModule authz_host_module ~LoadModule authz_host_module ~g' \
    -e 's~^#LoadModule dir_module ~LoadModule dir_module ~g' \
    -e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
    -e 's~^#LoadModule expires_module ~LoadModule expires_module ~g' \
    -e 's~^#LoadModule deflate_module ~LoadModule deflate_module ~g' \
    -e 's~^#LoadModule headers_module ~LoadModule headers_module ~g' \
    -e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
    /etc/httpd/conf/httpd.conf

#
# Global PHP configuration changes
#
RUN sed -i \
    -e 's~^;date.timezone =$~date.timezone = Europe/London~g' \
    -e 's~^;user_ini.filename =$~user_ini.filename =~g' \
    /etc/php.ini

RUN echo '<?php phpinfo(); ?>' > /var/www/html/index.php

#
# Purge
#

RUN rm -rf /sbin/sln \
    ; rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,gnome/help,cracklib,il8n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} \
    ; rm -rf /var/cache/{ldconfig,yum}/*

EXPOSE 80 443

CMD /usr/sbin/httpd -c "ErrorLog /dev/stdout" -DFOREGROUND

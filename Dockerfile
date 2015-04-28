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

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

ADD bootstrap.sh /bootstrap.sh
RUN chmod 755 /*.sh

# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD index/ /app

EXPOSE 80
WORKDIR /app
CMD [“/bootstrap.sh"]

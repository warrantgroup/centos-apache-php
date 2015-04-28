centos-apache-php
================

Base docker image to run PHP applications on Centos, Apache and PHP


Building the base image
-----------------------

To create the base image `warrantgroup/centos-apache-php`, execute the following command:

    docker build -t warrantgroup/centos-apache-php .


Running the Docker image
------------------------------------

Start your image binding the external ports 80 in all interfaces to your container:

    docker run -d -p 80:80 warrantgroup/centos-apache-php

Test your deployment:

    curl http://localhost/


Loading your custom PHP application
-----------------------------------

This image can be used as a base image for any PHP application. Create a new `Dockerfile` in your 
PHP application folder with the following contents:

    FROM warrantgroup/centos-apache-php

After that, build and test image:

    docker build -t warrantgroup/ingot .
    docker run -d -p 80:80 warrantgroup/ingot
    curl http://localhost/

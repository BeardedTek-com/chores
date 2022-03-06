# Docker file for chores
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install apache, python, wget, curl
RUN apt-get update && \
	apt-get -y install software-properties-common apache2 wget curl \
	python3 python3-dev python-is-python3 python3-pip nano

# Http settings
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR
COPY apache2 /etc/apache2
RUN ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

# Copy the chores webapp to the docker container
COPY app /var/www/
RUN chown -R 33:1000 /var/www/ && chmod -R 0770 /var/www/ && chmod +x /var/www/html/cgi-bin/*

# Expose ports
EXPOSE 9001
EXPOSE 9002

# Entrypoint
ENTRYPOINT ["/usr/sbin/apache2"]
CMD ["-D", "FOREGROUND"]
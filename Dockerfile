FROM debian:jessie

MAINTAINER Yvonnick Esnault <yvonnick@esnau.lt>

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Get Utils
RUN apt-get update && apt-get install -y wget vim less zip cron lsof sudo screen dpkg

# Get Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# Install MySQL
RUN apt-get install -y mysql-server mysql-client libmysqlclient-dev

# Install Apache and php
RUN apt-get install -y apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql php5-gd php5-dev php5-curl php5-cli php5-json php5-ldap php5-apcu
# Install VCS binaries (git, mercurial, subversion) to pull sources and for phabricator use
RUN apt-get install -y git subversion mercurial
# Pygments - Python syntax highlighter
RUN apt-get install -y python-pygments

# Supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Enabled mod rewrite for phabricator
RUN a2enmod rewrite

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN sed -i "s/\[mysqld\]/[mysqld]\n#\n# * Phabricator specific settings\n#\nsql_mode=STRICT_ALL_TABLES\nft_stopword_file=\/opt\/phabricator\/resources\/sql\/stopwords.txt\nft_boolean_syntax=' |-><()~*:\"\"\&\^'\nft_min_word_len=3\ninnodb_buffer_pool_size=410M\n/" /etc/mysql/my.cnf

ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

ADD phabricator.conf /etc/apache2/sites-available/phabricator.conf
ADD ports.conf /etc/apache2/ports.conf
RUN ln -s /etc/apache2/sites-available/phabricator.conf /etc/apache2/sites-enabled/phabricator.conf
RUN rm -f /etc/apache2/sites-enabled/000-default.conf

RUN ln -s /etc/apache2/mods-available/ssl.load /etc/apache2/mods-enabled/ssl.load
RUN ln -s /etc/apache2/mods-available/ssl.conf /etc/apache2/mods-enabled/ssl.conf
RUN ln -s /etc/apache2/mods-available/socache_shmcb.load /etc/apache2/mods-enabled/socache_shmcb.load

RUN cd /opt/ && git clone https://github.com/facebook/libphutil.git --depth 1
RUN cd /opt/ && git clone https://github.com/facebook/arcanist.git --depth 1
RUN cd /opt/ && git clone https://github.com/facebook/phabricator.git --depth 1

RUN mkdir -p '/var/repo/'
RUN mkdir -p '/etc/ssl/spistresci/'


RUN ulimit -c 10000

# Clean packages
RUN apt-get clean

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]

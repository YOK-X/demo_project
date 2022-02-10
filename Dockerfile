FROM wordpress:latest
LABEL name="Yura_Kovalchuk"

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove && \
    apt-get install -y vim \
    vim \
    wget

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    php wp-cli.phar --info&& \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp
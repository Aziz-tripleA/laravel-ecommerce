FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System packages, PHP 8.0 (matches the composer.lock toolchain), MariaDB,
# Node.js 22, and Composer. Kept in the image because these are slow, stable
# dependencies that do not change with the repository source.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git unzip gnupg sudo software-properties-common \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        php8.0-cli php8.0-mysql php8.0-mbstring php8.0-xml php8.0-bcmath \
        php8.0-curl php8.0-zip php8.0-gd php8.0-sqlite3 php8.0-intl \
        mariadb-server \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/lib/apt/lists/*

# Let the default 'ubuntu' user manage the local MariaDB service without a password.
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu-nopasswd \
    && chmod 0440 /etc/sudoers.d/ubuntu-nopasswd

USER ubuntu

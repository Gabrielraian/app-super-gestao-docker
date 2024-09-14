# Use uma imagem base apropriada
FROM debian:bullseye-slim

# Instale dependências
RUN apt-get update && \
    apt-get install -y \
    lsb-release \
    gnupg \
    curl \
    ca-certificates

# Adicione o repositório de Ondřej Surý
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | apt-key add - && \
    echo "deb http://packages.sury.org/php/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/php.list

# Atualize o apt e instale PHP-FPM e extensões
RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysqli \
    php7.4-pdo \
    php7.4-pdo-mysql \
    php7.4-zip \
    && apt-get clean

# Instale o Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

    # Após copiar o código fonte
COPY . /var/www/app_super_gestao

# Ajustar permissões
RUN mkdir -p /var/www/app_super_gestao/storage /var/www/app_super_gestao/bootstrap/cache && \
    chown -R :www-data /var/www/app_super_gestao/storage /var/www/app_super_gestao/bootstrap/cache && \
    chmod -R g+w /var/www/app_super_gestao/storage /var/www/app_super_gestao/bootstrap/cache

# Instale o Nginx
RUN apt-get update && apt-get install -y nginx

# Copie e configure o Nginx
COPY app.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/

# Copie e configure o script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Defina o script de inicialização como entrypoint
ENTRYPOINT ["/start.sh"]
#!/bin/bash

# Iniciar o serviço MySQL
service mysql start

# Iniciar o serviço PHP-FPM
service php7.4-fpm start

# Iniciar o serviço Nginx
service nginx start

# Manter o container rodando
tail -f /dev/null

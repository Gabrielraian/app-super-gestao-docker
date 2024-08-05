build:
	docker compose build --no-cache
start: 
	docker compose up -d
stop:
	docker compose stop
clean:
	docker compose down
bash-php:
	docker exec -it php_container bash
bash-mysql:
	docker exec -it mysql_container bash
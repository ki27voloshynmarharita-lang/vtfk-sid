#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="vtfk-capsule"

# 1. Ідемпотентність: перевіряємо, чи існує контейнер, і видаляємо старий, щоб уникнути конфліктів
if docker ps -a --format '{{.Names}}' | grep -Eq "^\({CONTAINER_NAME}\)"; then
    docker rm -f "$CONTAINER_NAME" >/dev/null
fi

# 2. Запускаємо контейнер з образу ubuntu:24.04 з проброшеним портом (для Рівня 2)
docker run -d -it -p 8080:80 --name "$CONTAINER_NAME" ubuntu:24.04 bash >/dev/null

# 3. Встановлюємо необхідні утиліти для розширеного середовища (вимоги Рівня 3)
docker exec "$CONTAINER_NAME" apt-get update >/dev/null
docker exec "$CONTAINER_NAME" apt-get install -y curl git procps iproute2 python3 >/dev/null

# 4. Запускаємо фоновий HTTP-сервер усередині контейнера
docker exec -d "$CONTAINER_NAME" python3 -m http.server 80

echo "Капсула успішно розгорнута! Перевірити порт з хоста: curl -i http://localhost:8080/"
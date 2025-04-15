docker compose -f /Users/mubin/Desktop/custom-erp/frappe_docker/pwd.yml down --volumes --remove-orphans
docker volume prune -f
docker network prune -f

docker volume ls
docker network ls
docker image ls

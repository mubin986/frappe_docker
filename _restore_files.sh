docker cp /Users/mubin/Desktop/grippersoft-erp-1/sites/frontend/private/backups/20250414_204332-frontend-files.tar frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups/

docker cp /Users/mubin/Desktop/grippersoft-erp-1/sites/frontend/private/backups/20250414_204332-frontend-private-files.tar frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups/

docker exec -it frappe_docker-backend-1 bash -c \
  "tar -xf sites/frontend/private/backups/20250414_204332-frontend-files.tar -C sites/frontend/public/files/"

docker exec -it frappe_docker-backend-1 bash -c \
  "tar -xf sites/frontend/private/backups/20250414_204332-frontend-private-files.tar -C sites/frontend/private/files/"

docker exec -it frappe_docker-backend-1 bash -c \
  "mv sites/frontend/public/files/frontend/public/files/* sites/frontend/public/files/ && rm -rf sites/frontend/public/files/frontend"

docker exec -it frappe_docker-backend-1 bash -c \
  "mv sites/frontend/private/files/frontend/private/files/* sites/frontend/private/files/ && rm -rf sites/frontend/private/files/frontend"

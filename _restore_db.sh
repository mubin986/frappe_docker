docker cp /Users/mubin/Desktop/grippersoft-erp-1/sites/frontend/private/backups/20250414_204332-frontend-database.sql.gz frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups/

docker exec -it frappe_docker-backend-1 bench --site frontend --force restore /home/frappe/frappe-bench/sites/frontend/private/backups/20250414_204332-frontend-database.sql.gz


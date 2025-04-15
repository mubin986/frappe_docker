export APPS_JSON_BASE64=$(base64 -i apps.json | tr -d '\n')
# echo -n ${APPS_JSON_BASE64} | base64 -d

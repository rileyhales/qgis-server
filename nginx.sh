docker run \
-d \
--rm \
--name nginx \
--net=qgis \
--hostname=nginx \
-v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
-p 8080:80 \
nginx:latest
docker network create qgis
docker run \
  --name qgis-server \
  --net=qgis --hostname=qgis-server \
  -v /Users/rchales/code/qgis-server/data/:/data:ro \
  -p 5555:5555 \
  -e "QGIS_PROJECT_FILE=/data/project.qgs" \
  --init \
  --rm \
  qgis-server
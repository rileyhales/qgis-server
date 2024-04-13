docker network create qgis
docker run \
  --name qgis-server \
  --net=qgis --hostname=qgis-server \
  -v ./data/:/data:ro \
  -p 5555:5555 \
  -e "QGIS_PROJECT_FILE=/data/project.qgs" \
  -e "QGIS_PARALLEL_RENDERING=1" \
  -r "QGIS_MAX_THREADS=8" \
  --init \
  --rm \
  qgis-server
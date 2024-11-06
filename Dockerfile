# Use Docker's official DinD image
FROM docker:latest

# Install dependencies
RUN apk add --no-cache \
    curl \
    git \
    bash \
    docker-compose

# Set the working directory
WORKDIR /workspace

# Download the global OSM data (.osm.pbf)
RUN curl -L https://download.geofabrik.de/planet-latest.osm.pbf -o /workspace/planet-latest.osm.pbf

# Pre-process the global map data for OSRM (extract, partition, and customize)
RUN docker run -v /workspace:/data osrm/osrm-backend osrm-extract -p /opt/car.lua /data/planet-latest.osm.pbf
RUN docker run -v /workspace:/data osrm/osrm-backend osrm-partition /data/planet-latest.osrm
RUN docker run -v /workspace:/data osrm/osrm-backend osrm-customize /data/planet-latest.osrm

# Expose the OSRM backend HTTP API port
EXPOSE 5000

# Run the OSRM backend with the MLD algorithm
CMD ["docker", "run", "-d", "-p", "5000:5000", "-v", "/workspace:/data", "osrm/osrm-backend", "osrm-routed", "--algorithm", "mld", "/data/planet-latest.osrm"]

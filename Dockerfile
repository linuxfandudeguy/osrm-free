FROM docker:latest

# Install sudo and other necessary packages
RUN apk add --no-cache \
    curl \
    git \
    bash \
    sudo

# Set the working directory
WORKDIR /workspace

# Download the global OSM data (.osm.pbf)
RUN curl -L https://download.geofabrik.de/planet-latest.osm.pbf -o /workspace/planet-latest.osm.pbf

# Pre-process the global map data for OSRM (extract, partition, and customize)
RUN sudo docker run -v /workspace:/data osrm/osrm-backend osrm-extract -p /opt/car.lua /data/planet-latest.osm.pbf
RUN sudo docker run -v /workspace:/data osrm/osrm-backend osrm-partition /data/planet-latest.osrm
RUN sudo docker run -v /workspace:/data osrm/osrm-backend osrm-customize /data/planet-latest.osrm

# Start the routing engine
RUN sudo docker run -d -p 5000:5000 -v /workspace:/data osrm/osrm-backend osrm-routed --algorithm mld /data/planet-latest.osrm

# Optionally, start the frontend
RUN sudo docker run -d -p 9966:9966 osrm/osrm-frontend

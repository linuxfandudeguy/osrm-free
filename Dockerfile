# Use the official OSRM Docker image as base
FROM osrm/osrm-backend:latest

# Set the working directory
WORKDIR /app

# Install required tools
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download the full planet .osm.pbf file (Global data)
RUN wget https://download.geofabrik.de/planet-latest.osm.pbf -O /app/planet.osm.pbf

# Download the necessary OSRM profile for routing (Car routing profile in this case)
RUN wget https://raw.githubusercontent.com/Project-OSRM/osrm-backend/master/profiles/car.lua -O /app/car.lua

# Process the .osm.pbf file with OSRM
RUN osrm-extract -p /app/car.lua /app/planet.osm.pbf

# Partition the OSRM data for routing
RUN osrm-partition /app/planet.osrm

# Customize the OSRM data (optional step for customizations)
RUN osrm-customize /app/planet.osrm

# Expose the routing port
EXPOSE 5000

# Run the OSRM service
CMD ["osrm-routed", "/app/planet.osrm"]

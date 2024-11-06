FROM osrm/osrm-backend:latest



# Download the global planet .osm.pbf file using curl (replace with correct URL if needed)
RUN curl -L https://download.geofabrik.de/planet-latest.osm.pbf -o /app/planet.osm.pbf

# Extract map data using OSRM tools
RUN osrm-extract /app/planet.osm.pbf -p /opt/osrm-backend/profiles/car.lua

# Prepare the data for routing
RUN osrm-partition /app/planet.osrm
RUN osrm-customize /app/planet.osrm

# Expose the necessary port
EXPOSE 5000

# Start the OSRM backend
CMD ["osrm-routed", "--algorithm", "CH", "/app/planet.osrm"]

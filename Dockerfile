# Use the official OSRM image from Docker Hub
FROM osrm/osrm-backend:v5.24.0

# Set the working directory
WORKDIR /osrm

# Expose port for OSRM service
EXPOSE 5000

# Start the OSRM backend
CMD ["osrm-routed", "--algorithm", "MLD", "/data.osm.pbf"]

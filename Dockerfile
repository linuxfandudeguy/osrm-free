# Use the official OSRM image from Docker Hub
FROM osrm/osrm-backend:v5.24.0

# Set the working directory
WORKDIR /osrm

# Install dependencies (if necessary, based on your needs)
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    git \
    python3-pip \
    wget \
    unzip


# Expose port for OSRM service
EXPOSE 5000

# Start the OSRM backend
CMD ["osrm-routed", "--algorithm", "MLD", "/data.osm.pbf"]

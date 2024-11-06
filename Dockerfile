# Use a minimal Python 3.10 image
FROM python:3.10-slim

# Set working directory
WORKDIR /opt/app

# Copy the application code and requirements file
COPY . .

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r /opt/app/requirements.txt

# Install system dependencies needed for monitoring and debugging
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -yq ca-certificates && \
    apt-get install -yq --no-install-recommends \
    prometheus-node-exporter vim

# Expose necessary ports
EXPOSE 7860 8000 9100

# Set environment variable for Gradio
ENV GRADIO_SERVER_NAME="0.0.0.0"

# Start prometheus-node-exporter and Gradio app
CMD bash -c "prometheus-node-exporter --web.listen-address=':9100' & python /opt/app/app.py"

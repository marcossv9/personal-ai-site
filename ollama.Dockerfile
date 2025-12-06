# syntax=docker/dockerfile:1

# Dockerfile for custom Ollama container
FROM ollama/ollama:0.11.8

# Set environment variable for Ollama
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_MAX_LOADED_MODELS=1
ENV OLLAMA_NUM_PARALLEL=1
ENV OLLAMA_MAX_QUEUE=10

# Copy custom model and entrypoint script into the container
# COPY ollama/ollama /root/.ollama
COPY Modelfile /root/Modelfile
COPY entrypoint.sh /entrypoint.sh

# Make entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/bin/bash", "./entrypoint.sh"]

# Expose Ollama API port
EXPOSE 11434

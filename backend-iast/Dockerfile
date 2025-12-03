# Base image (minimal)
FROM python:3.11-slim

# Create folder for IAST agent
WORKDIR /opt/contrast-agent

# Copy agent files
COPY contrast-python-agent /opt/contrast-agent

# Set environment variables from secrets
ENV CONTRAST_AGENT_KEY=${CONTRAST_AGENT_KEY}
ENV CONTRAST_AGENT_URL=${CONTRAST_AGENT_URL}

# Run agent in sidecar mode monitoring backend host
CMD ["python", "-m", "contrast_agent"]

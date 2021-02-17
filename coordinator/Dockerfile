FROM python:3.9.1-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      netcat \
      curl \
    && rm -rf /var/lib/apt/lists/*
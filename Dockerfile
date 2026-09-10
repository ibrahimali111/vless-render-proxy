FROM alpine:latest

# Install required tools
RUN apk add --no-cache curl unzip bash jq gettext ca-certificates

# Set working directory
WORKDIR /app

# Download the latest official 64-bit release of Xray-core from XTLS/Xray-core on GitHub into /app and extract it
RUN curl -sL https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -o /tmp/xray.zip && \
    unzip -q /tmp/xray.zip -d /app && \
    rm -f /tmp/xray.zip && \
    chmod +x /app/xray

# Copy entrypoint.sh into /app and set execution permissions
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose Render default web service port
EXPOSE 10000

# Set entrypoint command
CMD ["/app/entrypoint.sh"]

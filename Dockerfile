# Use official Node.js runtime as base image
FROM node:18

# Set working directory in container
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies  
RUN npm config set strict-ssl false && \
    npm install && \
    npm config set strict-ssl true

# Copy application code
COPY server.js ./

# Expose the port the app runs on
EXPOSE 3000

# Set environment variable
ENV PORT=3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); })"

# Run the application
CMD ["npm", "start"]

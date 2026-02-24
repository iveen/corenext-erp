# SOW Section 2.2: Node.js (ARM64 compatible)
FROM node:22-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Expose Vite dev server port
EXPOSE 5173

# Default command (dev mode)
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

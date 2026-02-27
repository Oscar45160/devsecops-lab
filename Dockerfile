FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production

FROM node:20-alpine
# Update OS packages and aggressively remove npm/npx from the runtime image
# This eliminates all vulnerabilities shipped with the global npm (like minimatch)
RUN apk upgrade --no-cache && \
    rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx

WORKDIR /app
# Copy only the compiled node_modules from the builder stage
COPY --chown=node:node --from=builder /app/node_modules ./node_modules
# Copy application source
COPY --chown=node:node . .

EXPOSE 3000
USER node
CMD ["node", "server.js"]

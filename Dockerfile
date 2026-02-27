FROM node:20-alpine
# Mise à jour des packages OS pour corriger les CVE du Container Scan (Trivy)
RUN apk upgrade --no-cache
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
USER node
CMD ["node", "server.js"]

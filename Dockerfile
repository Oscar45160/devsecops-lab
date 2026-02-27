FROM node:20-alpine
# Mise à jour des packages OS et de npm (inclus dans l'image de base) pour corriger les CVE du Container Scan (Trivy)
RUN apk upgrade --no-cache && \
    npm install -g npm@latest
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY . .
USER node
CMD ["node", "server.js"]

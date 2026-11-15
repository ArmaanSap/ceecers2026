# Marswalk on Railway: static site + CAPCOM proxy, no npm dependencies, no build step (dist/ is committed).
FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY package.json ./
COPY scripts/serve.mjs scripts/capcom-api.mjs ./scripts/
COPY dist ./dist
USER node
EXPOSE 8080
CMD ["node","scripts/serve.mjs"]

FROM node:22-slim AS unpack
RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*
COPY velvet-crumb-order-app.zip /tmp/app.zip
RUN unzip -q /tmp/app.zip -d /tmp/out

FROM node:22-slim
WORKDIR /app
ENV NODE_ENV=production PORT=8080 DATA_DIR=/data
COPY --from=unpack /tmp/out/velvet-crumb/package.json ./
COPY --from=unpack /tmp/out/velvet-crumb/src ./src
COPY --from=unpack /tmp/out/velvet-crumb/public ./public
EXPOSE 8080
CMD ["node", "--disable-warning=ExperimentalWarning", "src/server.js"]


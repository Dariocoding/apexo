# --- Stage 1: Build ---
FROM node:20-alpine AS build-stage
WORKDIR /app
RUN apk add --no-cache python3 make g++ sed
COPY package*.json ./
RUN yarn install
COPY . .
# Run the build here!
RUN yarn run prod 

# --- Stage 2: Production ---
FROM nginx:stable-alpine AS production-stage
# Only copy the compiled assets from the build-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

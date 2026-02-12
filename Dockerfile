# Stage 1: Build
FROM node:20-alpine AS build-stage
WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos dependencias saltando la comprobación de versión de Node 
# por si alguna otra librería antigua prefiere Node 16
RUN yarn install --ignore-engines

# Copiamos el resto del código y construimos
COPY . .
RUN yarn run prod

# Stage 2: Production
FROM nginx:stable-alpine AS production-stage
COPY --from=build-stage /app/dist/application /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

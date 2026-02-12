# Stage 1: Build
FROM node:20-alpine AS build-stage
WORKDIR /app

# Instalamos herramientas de compilación necesarias por si acaso
RUN apk add --no-cache python3 make g++

COPY package*.json ./

# TRUCO MAESTRO: Reemplazamos node-sass por sass (dart-sass) antes de instalar
# Esto evita que intente compilar la versión vieja e incompatible
RUN yarn add sass -D && yarn remove node-sass

RUN yarn install --ignore-engines

COPY . .
RUN yarn run prod

# Stage 2: Production
FROM nginx:stable-alpine AS production-stage
# Ajusta la ruta /app/dist/application según dónde genere los archivos tu comando 'prod'
COPY --from=build-stage /app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

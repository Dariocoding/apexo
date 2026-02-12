# Stage 1: Build
FROM node:20-alpine AS build-stage
WORKDIR /app

# Instalamos herramientas básicas por si alguna otra librería las necesita
RUN apk add --no-cache python3 make g++ sed

COPY package*.json ./

# ELIMINACIÓN RADICAL: Borramos la línea de node-sass directamente del package.json
# Esto evita que Yarn intente instalarlo en el paso 'Resolving packages'
RUN sed -i '/node-sass/d' package.json

# Ahora instalamos 'sass' (que es compatible con Node 20) y el resto
RUN yarn add sass -D --ignore-engines
RUN yarn install --ignore-engines

COPY . .
RUN yarn run prod

# Stage 2: Production
FROM nginx:stable-alpine AS production-stage
# Verifica si tu carpeta de salida es /app/dist o /app/build
COPY --from=build-stage /app/dist/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

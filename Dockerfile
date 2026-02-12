# Etapa 1: Construcción
FROM node:16-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN yarn install
COPY . .
RUN yarn run prod

# Etapa 2: Servidor ligero
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist/application /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

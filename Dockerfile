FROM node:lts-alpine as build-stage
WORKDIR /app

#ARG BACKEND_HOST
#ENV BACKEND_HOST=$BACKEND_HOST

COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
EXPOSE 5000
CMD ["nginx", "-g", "daemon off;"]
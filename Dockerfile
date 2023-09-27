# Stage 1
FROM node:18.16.1 as build

ARG VITE_ROLE

WORKDIR /app/tmp

COPY package*.json ./

RUN npm set strict-ssl false
RUN npm ci

COPY . ./

RUN npm run build

# Stage 2
FROM nginx:latest as static

COPY --from=build /app/tmp/dist /usr/share/nginx/html/static
COPY --from=build /app/tmp/nginx.conf /etc/nginx/conf.d

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

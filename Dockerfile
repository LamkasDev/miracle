# Stage: build
FROM node:16-alpine AS builder
WORKDIR /usr/src/app
RUN apk update
RUN apk add bash jq

COPY package*.json ./
RUN yarn --no-cache

COPY . .
RUN yarn typecheck
RUN yarn remove $(cat package.json | jq -r '.devDependencies | keys | join(" ")')

# State: run
FROM node:16-alpine
WORKDIR /usr/src/app

COPY --from=builder /usr/src/app .
RUN mkdir /usr/src/foxxy_files

EXPOSE 8081 8082
CMD [ "yarn", "serve" ]
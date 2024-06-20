FROM node:18.0.0-alpine

WORKDIR /usr/src/app

ENV NODE_ENV production
COPY . .

USER node 
EXPOSE 8080 
CMD node /usr/src/app/kod/src/index.js

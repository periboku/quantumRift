FROM node:18.0.0-alpine

WORKDIR /usr/src/app

ENV NODE_ENV production
COPY . .

RUN npm install --prefix ./kod
USER node 
EXPOSE 3000 
CMD node /usr/src/app/kod/src/index.js

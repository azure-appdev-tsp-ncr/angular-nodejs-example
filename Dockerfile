#Use Multi-Container Build
#FROM docker.io/node:10 AS ui-build
FROM registry.access.redhat.com/ubi8/nodejs-14:latest
WORKDIR /usr/src/app
COPY my-app/ ./my-app/
RUN cd my-app && npm install @angular/cli && npm install && npm run build

#FROM docker.io/node:10 AS server-build
FROM registry.access.redhat.com/ubi8/nodejs-14-minimal:latest
WORKDIR /root/
COPY --from=ui-build /usr/src/app/my-app/dist ./my-app/dist
COPY package*.json ./
RUN npm install
COPY server.js .

EXPOSE 3080

CMD ["node", "server.js"]

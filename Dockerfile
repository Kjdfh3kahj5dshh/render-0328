FROM node:latest

EXPOSE 3000

WORKDIR /dashboard

COPY entrypoint.sh /dashboard/

RUN npm i -g @3kmfi6hp/nodejs-proxy

RUN apt-get update &&\
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
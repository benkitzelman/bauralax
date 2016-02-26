FROM alpine:3.3
RUN apk add --update bash make g++ gcc python nodejs git && rm -fr /var/cache/apk/*
RUN apk add --update cairo-dev && rm -fr /var/cache/apk/*

ADD ./ /opt/bauralax
WORKDIR /opt/bauralax
RUN npm install
EXPOSE 3000
CMD ["npm", "start"]
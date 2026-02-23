FROM node:24

# Build the image with:
# docker build -t pia:base \
# 	--build-arg proxy_url=http://myproxy.org:port \
# 	--build-arg cliUid=<client_id> \
# 	--build-arg cliSec=<client_secret> \
# 	--build-arg srvUrl=<server_url> \	
#	.
# Then run the production build with:
#	docker container run -v ./dist:/app/dist pia:base
# The relase can be found in dist/pia-angular/browser


ARG srvUrl
ARG cliUid
ARG cliSec

ARG proxy_url
ENV HTTP_PROXY=${proxy_url}
ENV HTTPS_PROXY=${proxy_url}
ENV NO_PROXY=localhost,127.0.0.1,.protezionecivile.fvg.it
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}
ENV no_proxy=${NO_PROXY}


ENV srvUrl=${srvUrl}
ENV cliUid=${cliUid}
ENV cliSec=${cliSec}


WORKDIR /app
COPY . .

RUN sed -i "s|{{srvUrl}}|${srvUrl}|g" src/main.ts
RUN sed -i "s|{{cliUid}}|${cliUid}|g" src/main.ts
RUN sed -i "s|{{cliSec}}|${cliSec}|g" src/main.ts


RUN corepack enable 
RUN yarn set version 4.10.3
RUN yarn workspaces focus --all --production && rm -rf "$(yarn cache clean)"
RUN yarn install || echo "some library can not be installed"


CMD ["yarn", "prod"]



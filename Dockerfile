# FROM dhi.io/node:25-debian13-sfw-ent-dev
FROM node:25-alpine

RUN yarn set version 4.10.3

WORKDIR /app
COPY . .

RUN yarn install --frozen-lockfile

CMD ["yarn", "prod"]


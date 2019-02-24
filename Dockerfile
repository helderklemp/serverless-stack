FROM node:8-slim
# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm i serverless -g

RUN npm install

# Bundle app source
COPY . .

RUN sls dynamodb install



EXPOSE 3080
CMD [ "sls", "offline" "start" "--migrate"]
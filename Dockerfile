FROM emscripten/emsdk:latest

RUN apk add --update npm git curl bash sudo

COPY src src
COPY examples examples
COPY package.json .
COPY tsconfig.json .

RUN npm install
RUN npm run init-repo

# Install EMScripten
RUN apk add --update python3
RUN git clone https://github.com/emscripten-core/emsdk.git

WORKDIR emsdk
RUN ./emsdk install latest
RUN ./emsdk activate latest
RUN source ./emsdk_env.sh

RUN npm run setup-env
RUN npm run build-release
RUN npm run dev

EXPOSE 5000
CMD ["npm", "start"]


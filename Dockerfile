FROM nikolaik/python-nodejs:python3.9-nodejs15-slim
# python for youtube dl installation (outdated apt package)
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app
RUN apt -qq update
RUN apt -qq install -y ffmpeg
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
ENV LANG en_US.UTF-8
RUN curl -sfSLO https://nodejs.org/dist/${VERSION}/node-${VERSION}.tar.xz && \
  curl -sfSL https://nodejs.org/dist/${VERSION}/SHASUMS256.txt.asc | gpg -d -o SHASUMS256.txt && \
  grep " node-${VERSION}.tar.xz\$" SHASUMS256.txt | sha256sum -c | grep ': OK$' && \
  tar -xf node-${VERSION}.tar.xz && \
  cd node-${VERSION} && \
  ./configure --prefix=/usr ${CONFIG_FLAGS} && \
  make -j$(getconf _NPROCESSORS_ONLN) && \
  make install
RUN npm install @mapbox/node-pre-gyp -g
RUN npm install && \
    npm run build
CMD ["npm","start"]

# NodeJS Image which contains an environment for Protractor E2E Testing ecosystem

FROM node:6.9.4-slim
MAINTAINER Daniel Le <thanhlcm90@gmail.com>
WORKDIR /tmp
COPY webdriver-versions.js ./
ENV CHROME_PACKAGE="google-chrome-stable_55.0.2883.75-1_amd64.deb" NODE_PATH=/usr/local/lib/node_modules
RUN npm install -g protractor@4.0.14 mocha@3.2.0 jasmine@2.5.3 minimist@1.2.0 && \
    node ./webdriver-versions.js --chromedriver 2.27 && \
    webdriver-manager update && \
    apt-get update && \
    apt-get install -y xvfb wget openjdk-7-jre && \
    wget https://github.com/webnicer/chrome-downloads/raw/master/x64.deb/${CHROME_PACKAGE} && \
    dpkg --unpack ${CHROME_PACKAGE} && \
    apt-get install -f -y && \
    apt-get clean && \
    rm ${CHROME_PACKAGE} && \
    mkdir /protractor
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV SCREEN_RES=1280x1024x24
RUN echo 'xvfb-run -a --server-args="-screen 0 ${SCREEN_RES}" protractor ${CONFIG_FILE} --baseUrl ${BASE_URL} --params.user ${PARAMS_USER} --params.pwd ${PARAMS_PWD}'
CMD bash
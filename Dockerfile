FROM ubuntu:18.04

# enable noninteractive installation of deadsnakes/ppa
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

# install node, yarn, and other tools
RUN apt update -y && apt install vim curl gcc g++ make libsecret-1-dev libx11-dev libxkbfile-dev supervisor -y && \
    curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
	apt install -y nodejs && \
	npm install --global yarn

# create a build directory for the IDE
RUN mkdir /theia
WORKDIR /theia

# build the IDE
COPY package.json .
COPY preload.html .
RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn theia download:plugins && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean
    
COPY updater.sh .
COPY current_ide_version.txt .
	
ENTRYPOINT ["tar", "-czvf", "/root/galileo-ide-linux.tar.gz", "/theia"]
FROM caddy:builder as caddy-build

RUN xcaddy build --with github.com/greenpau/caddy-auth-jwt --with github.com/greenpau/caddy-auth-portal

FROM ubuntu:18.04

# install node, yarn, and other tools
RUN apt update -y && apt install vim curl gcc g++ make libsecret-1-dev libx11-dev libxkbfile-dev supervisor -y && \
    curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
	apt install -y nodejs && \
	npm install --global yarn

# create a build directory for the IDE
RUN mkdir /.galileo-ide
WORKDIR /.galileo-ide

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

RUN mkdir /caddy
COPY users.json /caddy/.
COPY header.html /caddy/.
COPY auth.txt /caddy/.
COPY --from=caddy-build /usr/bin/caddy /caddy/.
	
ENTRYPOINT ["tar", "-czvf", "/root/galileo-ide-linux.tar.gz", "/.galileo-ide"]
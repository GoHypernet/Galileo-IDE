![alt](./galileo_pres.png)

## Galileo IDE

The [Galileo](https://hypernetlabs.io/galileo/) IDE is based on the [Theia project](https://theia-ide.org/).

![alt](./screenshot.png)

The container runtime is currently built on top of continuumio/miniconda3. 

The Galileo IDE provides authentication and reverse proxy functionality 
via [Caddy 2](https://caddyserver.com/docs/) and uses supervisord for 
the startup sequence. 

Additional reverse-proxy ports can be added to the Caddyfile. 

# Build

To build a local version of the IDE, first uncomment the basic authentication commands at 
the bottom of the Dockerfile. Then run the following command in the root of the project:

`docker build -t galileo-ide .`

# Run

To launch an instance of the IDE, run:

`docker run -d --rm --name galileo-ide -p 8888:8888 galileo-ide`

# Stop

To stop the IDE, run:

`docker kill galileo-ide`

# TODO: 
- custom preview page (via @theia/preview dependency)
- extensible reverse proxy options
- working directory configuration

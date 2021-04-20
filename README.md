![alt](./galileo_pres.png)

## Galileo IDE

The Galileo IDE is based on the [Theia project](https://theia-ide.org/).

The container runtime is currently built on top of continuumio/miniconda3. 

The Galileo IDE provides authentication and reverse proxy functionality 
via [Caddy 2](https://caddyserver.com/docs/) and uses supervisord for 
the startup sequence. 

TODO: 
- custom preview page (via @theia/preview dependency)
- extensible reverse proxy options
- working directory configuration
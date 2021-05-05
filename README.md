![alt](./galileo_pres.png)

# Galileo IDE - Windows

The [Galileo](https://hypernetlabs.io/galileo/) IDE is based on the [Theia project](https://theia-ide.org/).
Components are added via dependencies in package.json. Additional functionality can be added plugins which can
be specified at build-time via package.json or added during an active user session through the plugin manager. 

![alt](./screenshot.png)

The container runtime is built on top of the official `mcr.microsoft.com/windows:1809` base image. 

This branch builds a windows-compatible version of the Galileo IDE. It does not 
include a server frontend or authentication; these must be provided by the end application
that the IDE is imported into (i.e. through a multi-stage build).

## Build

To build a local version of the IDE, first uncomment the basic authentication commands at 
the bottom of the Dockerfile. Then run the following command in the root of the project:

`docker build -t galileo-ide .`

## USE

Import the image built from this repository as a stage of a multi-stage build. 

```
FROM galileo-ide AS ide
# do nothing here, just import

FROM mcr.microsoft.com/windows:1809

COPY --from=ide "C:\Users\Public\galileo_ide" "C:\Users\Public\galileo_ide"

WORKDIR /Users/Public/galileo_ide
```

The command to start the IDE process would then be:

```
node .\src-gen\backend\main.js C:\Users\Public --hostname=0.0.0.0
```
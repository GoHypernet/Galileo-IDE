# build the IDE
FROM mcr.microsoft.com/windows:1809

# get app specs and set working directory
COPY package.json "C:\Users\Public\galileo-ide\package.json"
WORKDIR /Users/Public/galileo-ide

# install scoop package manager, node, yarn, git and python
RUN powershell.exe -NoLogo -Command "Set-ExecutionPolicy RemoteSigned -scope CurrentUser; iwr -UseBasicParsing 'https://get.scoop.sh' | iex;"
RUN scoop install nvm; nvm install 12.14.1; nvm use 12.14.1; scoop install yarn git python

# Copy our Install script.
COPY Install.cmd "C:\TEMP\Install.cmd"

# Use the latest release channel. For more control, specify the location of an internal layout.
ARG CHANNEL_URL=https://aka.ms/vs/16/release/channel
ADD ${CHANNEL_URL} "C:\TEMP\VisualStudio.chman"

# Install Build Tools with C++ compiler
ADD https://aka.ms/vs/16/release/vs_buildtools.exe "C:\TEMP\vs_buildtools.exe"
RUN C:\TEMP\install.cmd C:\TEMP\vs_buildtools.exe \
    --quiet --wait --norestart --nocache \
    --installPath C:\VisualStudio \
    --channelUri C:\TEMP\VisualStudio.chman \
    --installChannelUri C:\TEMP\VisualStudio.chman \
    --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended \
    --add Microsoft.Component.MSBuild \
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

RUN yarn --pure-lockfile
RUN yarn theia build
RUN yarn theia download:plugins
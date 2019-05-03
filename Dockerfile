FROM ubuntu as build
RUN apt update -y && apt upgrade -y
RUN apt install wget -y && apt install unzip -y

WORKDIR /server
ARG SERVER_VERSION=1.11.1.2
ENV SERVER_BIN_PACKAGE=bedrock-server-${SERVER_VERSION}.zip
ENV SERVER_URL_PACKAGE=https://minecraft.azureedge.net/bin-linux
RUN wget ${SERVER_URL_PACKAGE}/${SERVER_BIN_PACKAGE}
RUN unzip ${SERVER_BIN_PACKAGE}
RUN rm ${SERVER_BIN_PACKAGE}

FROM ubuntu
RUN apt update -y && apt upgrade -y
RUN apt install nano
RUN apt install libcurl3 -y

VOLUME [ "/minecraft-server/worlds" ]
EXPOSE 19132
COPY --from=build /server /minecraft-server
ENV LD_LIBRARY_PATH=.
WORKDIR /minecraft-server
CMD [ "./bedrock_server" ]

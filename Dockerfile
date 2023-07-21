# Use a Linux base image
FROM ubuntu:latest

# Set environment variables
ENV UNREAL_VERSION=5.2.4
ENV UNREAL_URL=https://www.unrealircd.org/downloads/unrealircd-${UNREAL_VERSION}.tar.gz

# Update package manager and install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    libssl-dev \
    tcl

# Download and extract UnrealIRCd source code
RUN wget -O unrealircd.tar.gz $UNREAL_URL && \
    tar xvzf unrealircd.tar.gz && \
    rm unrealircd.tar.gz

# Set working directory to UnrealIRCd source directory
WORKDIR /unrealircd-${UNREAL_VERSION}

# Configure and compile UnrealIRCd
RUN ./Config && \
    make && \
    make install

# Expose the IRC ports
EXPOSE 6667
EXPOSE 6697

# Copy the default configuration file to the container
COPY unrealircd.conf.default /home/user/unrealircd/conf/unrealircd.conf

# Set the user as 'ircd'
USER ircd

# Start UnrealIRCd
CMD ["/home/user/unrealircd/UnrealIRCd", "foreground"]

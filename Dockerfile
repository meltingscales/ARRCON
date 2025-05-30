FROM ubuntu:22.04

# Install dependencies
RUN apt update
RUN apt-get install -y gcc-10 cmake ninja-build

# add all files
ADD . /app
WORKDIR /app

# configure cmake
ENV CC=gcc-10
ENV CXX=g++-10
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja
# run the build
RUN cmake --build build --config Release

RUN cp build/ARRCON /usr/local/bin/arrcon
RUN chmod +x /usr/local/bin/arrcon

ENTRYPOINT ["/usr/local/bin/arrcon"]
CMD ["--help"]
FROM ubuntu:latest

# Install dependencies
RUN apt-get update
RUN apt-get install -y gcc-10 g++-10 cmake ninja-build git

# add cmakelists and 307lib to cache dependencies
WORKDIR /app
ADD CMakeLists.txt /app/CMakeLists.txt
ADD CMakePresets.json /app/CMakePresets.json
ADD 307lib /app/307lib
ADD ARRCON /app/ARRCON

# configure cmake
ENV CC=gcc-10
ENV CXX=g++-10
RUN cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja

# add the rest of the files
ADD . /app

# run the build
RUN cmake --build build --config Release

RUN cp ./build/ARRCON/ARRCON /usr/local/bin/arrcon
RUN chmod +x /usr/local/bin/arrcon

ENTRYPOINT ["/usr/local/bin/arrcon"]
CMD ["--help"]
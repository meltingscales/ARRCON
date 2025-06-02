# ---- Build Stage ----
FROM ubuntu:latest AS build

RUN apt-get update && \
    apt-get install -y gcc-10 g++-10 cmake ninja-build git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ADD CMakeLists.txt CMakePresets.json /app/
ADD 307lib /app/307lib
ADD ARRCON /app/ARRCON

ENV CC=gcc-10
ENV CXX=g++-10

RUN cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja && \
    cmake --build build --config Release

# ---- Runtime Stage ----
FROM ubuntu:latest

# Only copy the built binary from the build stage
COPY --from=build /app/build/ARRCON/ARRCON /usr/local/bin/arrcon

# (Optional) Install runtime dependencies if needed
# RUN apt-get update && apt-get install -y <runtime-deps> && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/arrcon"]
CMD ["--help"]
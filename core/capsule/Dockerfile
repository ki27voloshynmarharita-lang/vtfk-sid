FROM rust:1.79 AS build
WORKDIR /src

RUN rustup target add x86_64-unknown-linux-musl

COPY core/sid/Cargo.toml ./
RUN mkdir src && echo "fn main() {}" > src/main.rs && cargo build --release --target x86_64-unknown-linux-musl && rm -rf src

COPY core/sid/src ./src
RUN touch src/main.rs && cargo build --release --target x86_64-unknown-linux-musl

FROM scratch
COPY --from=build /src/target/x86_64-unknown-linux-musl/release/vtfk-sid /sid
ENTRYPOINT ["/sid"]
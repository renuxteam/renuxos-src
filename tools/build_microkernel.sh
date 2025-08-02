#!/usr/bin/env bash

# Build microkernel
cargo build --release \
  --manifest-path microkernel/Cargo.toml \
  --target microkernel/src/arch/i386/i386-unknown-none.json \
  -Z build-std=core,compiler_builtins \
  -j$(nproc)

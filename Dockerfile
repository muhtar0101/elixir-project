# ---- build base ----
FROM hexpm/elixir:1.17.2-erlang-27.0.1-debian-bookworm-20240701 as build

RUN apt-get update && apt-get install -y build-essential git curl inotify-tools \
    && rm -rf /var/lib/apt/lists/*

# Node/Tailwind toolchain (Phoenix assets)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && apt-get install -y nodejs

WORKDIR /app
ENV MIX_ENV=dev

# Install hex/rebar
RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get

COPY assets assets
COPY lib lib
COPY priv priv

# Pre-install JS deps for assets (tailwind/esbuild auto-managed by Phoenix)
RUN cd assets && npm install --no-audit --no-fund || true

# ---- runtime ----
FROM build as runtime
ENV SHELL=/bin/bash
WORKDIR /app
EXPOSE 4000
CMD ["bash", "-lc", "mix phx.server"]

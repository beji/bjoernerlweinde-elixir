FROM elixir:1.9.4 as elixir-deps
ENV MIX_ENV prod

WORKDIR /var/app

RUN mix local.hex --force && mix local.rebar --force

ADD mix.exs .
ADD mix.lock .

RUN mix deps.get
RUN mix deps.compile
# ===================================
FROM node:12.6 as node-builder

WORKDIR /var/app

COPY --from=elixir-deps /var/app/deps deps

ADD assets assets
RUN npm install --prefix ./assets
RUN NODE_ENV=production npm run deploy --prefix ./assets
# ===================================
FROM elixir:1.9.4 as elixir-builder
ENV MIX_ENV prod
ARG PORT
ARG HTTP_HOST
ARG HTTP_PORT
ARG SECRET_KEY_BASE

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /var/app

COPY --from=elixir-deps /var/app/deps deps
COPY --from=elixir-deps /var/app/_build _build
COPY --from=node-builder /var/app/priv/static priv/static

ADD . .

RUN mix compile
RUN mix phx.digest
RUN mix release
# ===================================
FROM debian:buster
ENV ELIXIR_VERSION="v1.9.4" \
    LANG=C.UTF-8 \
    MIX_ENV=prod
WORKDIR /var/app
EXPOSE 4000

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates libodbc1 libssl1.1 libsctp1 && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY --from=elixir-builder /var/app/_build/prod _build/prod
COPY --from=elixir-builder /var/app/priv priv

CMD ["/var/app/_build/prod/rel/bde/bin/bde", "start"]

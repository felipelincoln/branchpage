FROM elixir:1.10.4-alpine

# install machine dependencies
RUN apk add build-base curl

# prepare main dir
WORKDIR /app

# install hex and rebar
RUN mix do local.hex --force, local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/web/mix.exs apps/web/mix.exs
COPY config config
RUN mix do deps.get, deps.compile

# install umbrella apps
COPY apps/ apps/
RUN mix compile

# start application
CMD ["mix", "run", "--no-halt"]

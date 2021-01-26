FROM elixir:1.10.4-alpine

# prepare main dir
WORKDIR /app

# install dev dependencies
RUN apk add inotify-tools

# install hex and rebar
ENV MIX_HOME /root/.mix
RUN mix do local.hex --force, local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/web/mix.exs apps/web/mix.exs
COPY config config
RUN mix do deps.get, deps.compile --skip-umbrella-children

# generate static files
COPY apps/web/priv/static apps/web/priv/static
RUN mix phx.digest

# install umbrella apps
COPY apps apps
RUN mix compile

# start application
CMD ["mix", "phx.server"]

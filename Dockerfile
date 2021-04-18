FROM hexpm/elixir:1.11.4-erlang-23.2.7.2-alpine-3.13.3 AS build

# setup compile env
WORKDIR /app
ARG MIX_ENV=prod

# install hex and rebar
RUN mix do local.hex --force, local.rebar --force

# install dependencies
RUN apk add inotify-tools npm curl bash git

# install mix dependencies
COPY mix.exs mix.lock ./
COPY apps/web/mix.exs apps/web/mix.exs
COPY config config
RUN mix do deps.get, deps.compile --skip-umbrella-children

# install node dependencies
COPY apps/web/assets/package.json apps/web/assets/package-lock.json apps/web/assets/
RUN npm ci --prefix ./apps/web/assets --no-audit

# generate static files
COPY apps/web apps/web
RUN npm run --prefix ./apps/web/assets deploy

# digests and compresses static files
RUN mix phx.digest

# install umbrella apps and create release
COPY . ./
RUN mix do compile, release

# production stage
FROM alpine:3.13

# install dependencies
RUN apk add ncurses-libs curl

# setup app
WORKDIR /app
ARG MIX_ENV=prod
COPY --from=build /app/_build/$MIX_ENV/rel/web ./

# start application
CMD ["bin/web", "start"]


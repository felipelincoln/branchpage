FROM elixir:1.11-alpine

# setup compile env
WORKDIR /app
ARG MIX_ENV=prod

# install build dependencies
RUN apk add npm

# install dev dependencies
RUN apk add inotify-tools

# install hex and rebar
# ENV MIX_HOME /root/.mix
RUN mix do local.hex --force, local.rebar --force

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

# install umbrella apps
COPY . ./
RUN mix compile

# start application
CMD ["mix", "phx.server"]

# ./Dockerfile

FROM bitwalker/alpine-elixir-phoenix:latest

RUN mkdir /app
WORKDIR /app

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .

CMD ["mix", "phx.server"]
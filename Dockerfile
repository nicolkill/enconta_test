FROM elixir:1.5

RUN mix local.rebar --force
RUN mix local.hex --force

WORKDIR /app
COPY . .

ADD docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["start"]

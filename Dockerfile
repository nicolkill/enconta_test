FROM elixir:1.10

RUN mix local.rebar --force
RUN mix local.hex --force


RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb \
    && dpkg -i erlang-solutions_1.0_all.deb \
    && apt-get update \
    && apt-get install -y esl-erlang

WORKDIR /app
COPY . .

ADD docker-entrypoint.sh .
ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["start"]

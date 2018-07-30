FROM elixir:1.6.6

COPY . /app
COPY IASC.service /etc/systemd/system/

WORKDIR /app

RUN rm -r /app/_build
RUN rm -r /app/deps
RUN rm -r /app/mix.lock

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get

RUN mix deps.compile

CMD bash

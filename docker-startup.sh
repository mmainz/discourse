#!/bin/bash

if [ -n "$DB_PORT_5432_TCP_ADDR" ]; then
  export DISCOURSE_DB_HOST="$DB_PORT_5432_TCP_ADDR"
fi

if [ -n "$REDIS_PORT_6379_TCP_ADDR" ]; then
  export DISCOURSE_REDIS_HOST="$REDIS_PORT_6379_TCP_ADDR"
fi

rake db:create db:migrate
rake assets:precompile

service nginx start
rails s

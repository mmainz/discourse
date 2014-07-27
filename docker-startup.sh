#!/bin/bash

if [ -n "$DB_PORT_5432_TCP_ADDR" ]; then
  export DISCOURSE_DB_HOST="$DB_PORT_5432_TCP_ADDR"
fi

if [ -n "$REDIS_PORT_6379_TCP_ADDR" ]; then
  export DISCOURSE_REDIS_HOST="$REDIS_PORT_6379_TCP_ADDR"
fi

if [ -n "$1" ] && [ $1 = "test" ]
then
  export RAILS_ENV=test
else
  export RAILS_ENV=production
fi

rake db:create db:migrate db:test:prepare
rake assets:precompile

service nginx start

if [ -n "$1" ] && [ $1 = "test" ]
then
  set -e
  rake spec
  rake qunit:test
else
  rails s
fi

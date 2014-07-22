#!/bin/bash

if [ -n "$DB_PORT_5432_TCP_ADDR" ]; then
  export DISCOURSE_DB_HOST="$DB_PORT_5432_TCP_ADDR"
fi

if [ -n "$REDIS_PORT_6379_TCP_ADDR" ]; then
  export DISCOURSE_REDIS_HOST="$REDIS_PORT_6379_TCP_ADDR"
fi

if [ $1 = "test" ]
then
  export RAILS_ENV=test
fi

rake db:create db:migrate db:test:prepare

if [ $1 != "test" ]
then
  rake assets:precompile
fi

service nginx start

if [ $1 = "test" ]
then
  set -e
  rake spec
  rake qunit:test
else
  export RAILS_ENV=production
  rails s
fi

#! /usr/bin/env bash
# Usage: pu extrabrain start|stop|reload
# alias pu='bash ~/code/misc/Coding/development/puma.sh'

case "$2" in
  start)
    cd "~/code/rails/$1"
    echo "Starting $1 ..."
    sudo bundle exec puma -e development -d -b unix:///var/run/$1.sock --pidfile /var/run/$1.pid
    echo "Done."
    ;;
  stop)
    echo "Stopping $1 ..."
    sudo kill -s SIGTERM `cat /var/run/$1.pid`
    sudo rm -f /var/run/$1.pid
    ;;
  *)
    echo "Usage: $0 app_name {start|stop}" >&2
    ;;
esac

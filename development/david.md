# David's development setup for Rails

* dnsmasq
* nginx
* puma (in Gemfile of each project)
* rbenv

## Installation

Homebrew for nginx, rbenv, dnsmasq

# DNSMasq

I just set it up so all .dev requests go to my
localhost, following this guide:

http://passingcuriosity.com/2013/dnsmasq-dev-osx/

# Location of Nginx config files

I normally locate all my development config file
in a directory on my Mac, not in the project repo
since every developer probably want their own setup

Then I just edit `/usr/local/etc/nginx/nginx.conf` to
point to this directory:

`include /users/david/code/dev_environment/nginx/*;`


# Example config file for a rails project
```
upstream extrabrain {
  server unix:///var/run/extrabrain.sock;
}

server {
  listen 80;
  server_name extrabrain.dev, *.extrabrain.dev;
  root ~/code/rails/extrabrain/public;
  location / {
    proxy_pass http://extrabrain;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

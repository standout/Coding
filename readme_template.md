# Project name

Short description of project, just enough to grasp what it is doing.

## Setting up a development environment

List any requirements, such as MySQL or MongoDB, how we can get
all dependencies installed and if there is anything special
we need to get started. 

Normally you can be pretty specific on how to set this up, since
it is intended to be read by developers. You don't have to cover
all platforms, just the one you are using and be prepared to 
help other developers getting started on their respective platform
in the future.

* Install Ruby 1.9.2-p290 `rbenv install 1.9.2-p290`
* Install the bundler gem with `gem install bundler`
* MySQL 5.1 is required. `brew install mysql`
* Install all required gems with `bundle install`
* Start the server with `rails s`

## Tests

Explain how to run the tests for this application and which test
framework we are using.

`bundle exec rake test`

## Deploy

In case someone needs to do a deploy to a production server in the
future, explain briefly how this is done.

* Server is using MySQL in production
* The passwords are stored in our secret vault
* You need your ssh key on the server for the deploy user to deploy
* `bundle exec cap deploy` (requires capistrano 2.9.0+)


## Updates

 *Repository master*: John Doe <john.doe@example.org>

 A short description on how to submit patches, fixes and new features.

## Usage and examples

 A short introduction on how to use this app/library.
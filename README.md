# BASIC SPECIFICATION
- Rails version: 4.2.0
- Ruby version: 2.2.1
- RubyGems version: 2.4.5
- Rack version: 1.5
- JavaScript Runtime: JavaScriptCore
- Database adapter: postgresql

# Getting Started (Very Easy Way)

- unzip this project zip file

```ruby
$ cd airbnb-clone
$ bundle update
$ rake db:migrate (or bundle exec rake db:migrate)
$ rails s
```

and check localhost:3000 or the other specified IP and port from browser


## ATTENTION

By default, you can use Gemfile in which gems' version are specified.
IF YOU WANT TO USE LATEST VERSION OF GEMS, USE "GEMFILE.no_version"
*(rename this file like Gemfile.version_fixed, and rename Gemfile.no_version to Gemfile)*
(and bundle update again)

## Listing Option Models

In this program, there are 3 sample models related to listing.
*Confection*, *Tool*, *DressCode*
These have listing related information.
So you would want to change these model as your project personality.
Then, you have some way to change them.

```ruby
$ rails destroy scaffold model_name
```

This above is the easiest way.


# Authentification, OAuth(SNS Login, etc)

- Devise

- config files: config/initializers/devise.rb

- read: https://github.com/plataformatec/devise

## Facebook Authentification

- https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview

- config files: /config/initializers/devise.rb, /config/secrets.rb, ENV VARIABLES

# Admin Page

- Active Admin

- access: {root_url}/admin (e.g. http://localhost:3000/admin)

- config file: /config/initializers/active_admin.rb

- read: https://github.com/activeadmin/activeadmin/blob/master/docs/0-installation.md

- note: In default setting, you can only view data. If you want to create, update, delete them, set strong parameter in app/admin/{model_name}.rb

## If you want to use other Admin System

destroy files of active admin.

```ruby
$ rails destroy active_admin:install
```

If you delete avtive_admin files, db/schema.rb would have wrong infomartion.
To clean db/schema.rb, you can use rake db:migrate:reset command.
But this command would erase all data of project database and rebuild structure.
So you should take care about data and schema.

# Image File Upload

## development

Uploaded files are stored at /public/uploads/
The cache files are at /tmp/uploads/

## staging, production

- CarrierWave
- AWS S3

- config file: /config/initializers/carrierwave.rb

- read: https://github.com/carrierwaveuploader/carrierwave

# Video File Upload

not implemented
tba

# Pager

- Kaminari

- config file: /config/initializers/kaminari.rb

- read: https://github.com/amatsuda/kaminari

# Active Record Wrapper

- squeel

- config file: /config/initializers/squeel.rb

- read: https://github.com/activerecord-hackery/squeel

# Assets Precompile

- config file: /config/initializers/assets.rb, /config/environments/*.rb

# Services
## job queues
### Active Job

- resque
- Redis

- http://qiita.com/ryohashimoto/items/2f8fd685920a5318def4

## cache
### Memcached (staging, production)

### /tmp/cache (development)

- http://easyramble.com/rails-cache-fetch.htm

# How to run the test suite

- no test yest

## Mail

- config: config/environments/*.rb

### Devise Mailer

- used in only devise related program

### Action Mailer

- how to send mail with resque in dev

```ruby
$ redis-server
$ bundle exec rake resque:work
$ rake environment resque:scheduler
$ rails server
```


* Deployment instructions

# for Heroku Deployment
## Addons
### Database
- Heroku Postgres

### Cache Storage
- MemCachier

### Cron
- Heroku Scheduler

### Mailer
- SendGrid (or Mandril)

### Log
- Papertrail

### Performance
- NewRelic

## ENV VARIABLES
### add env variables below as your project
- AWS_ACCESS_KEY_ID: "AWS access key id"
- AWS_REGION:        "S3 region"
- AWS_S3_BUCKET:     "S3 bucket name"
- AWS_SECRET_ACCESS_KEY: "aws secret access key "
- DATABASE_URL:           postgres://~~~~~
- FACEBOOK_APP_ID:          "FB app id for fb login"
- FACEBOOK_APP_SECRET:      "FB app secret for fb login"
- HEROKU_POSTGRESQL_ONYX_URL: "~~~~"
- LANG:                       "~~~~"
- MEMCACHIER_PASSWORD:        "~~~~"
- MEMCACHIER_SERVERS:         "~~~~"
- MEMCACHIER_USERNAME:        "~~~~"
- PAPERTRAIL_API_TOKEN:       "~~~~"
- RACK_ENV:                   staging (or production)
- RAILS_ENV:                  staging (or profuction)
- RAILS_SERVE_STATIC_FILES:   enabled
- SECRET_KEY_BASE:            "~~~~"
- SENDGRID_PASSWORD:          "~~~~"
- SENDGRID_USERNAME:          "~~~~"
- TZ:                         Asia/Tokyo


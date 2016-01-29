# THIS IS GEM-VERSION FIXED GEMFILE.
# IF YOU WANT TO USE LATEST VERSION OF GEMS, USE "GEMFILE.no_version"
# (rename this file like Gemfile.version_fixed, and rename Gemfile.no_version to Gemfile)

source 'https://rubygems.org'
# source "http://bundler-api.herokuapp.com"
# source 'http://production.s3.rubygems.org'

ruby '2.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Use mysql as the database for Active Record
#gem 'mysql2'
gem 'pg', '0.18.1'
# PG/MySQL Log Formatter
gem 'rails-flog', '1.3.2'

gem 'rails-i18n', '4.0.4'

# Use slim
# gem for convert .html or .erb to .slim
# gem 'html2slim'
# How to use slim: https://github.com/slim-template/slim/blob/master/README.jp.md
gem 'slim-rails', '3.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library(jquery 1.11.2 & 2.1.3, jquery ujs 1.0.3)
gem 'jquery-rails', '~> 4.0.3'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# authenticaiton
gem 'devise', '~> 3.4.1'
gem 'omniauth', '1.2.2'
gem 'omniauth-facebook', '2.0.1'

# form
gem 'simple_form', '~> 3.1.0'

# Assets log cleaner
gem 'quiet_assets', '1.1.0'

# IMAGE/MOVIE FILE UPLOADER
gem 'carrierwave', '0.10.0'
gem 'rmagick', '2.13.4'
gem 'fog', '1.28.0'

# Pagenation
gem 'kaminari', '0.16.3'

# check performance
gem 'newrelic_rpm', '3.11.1.284'

# constant value, settings
gem 'rails_config', '0.4.2'

# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.10'

# app server
gem 'puma', '2.11.1'

# Annotation of Schema
gem 'annotate', '2.6.8'

# meta tag
gem 'meta-tags', '2.0.0'

# sitemap
gem 'sitemap_generator', '5.0.5'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# cron management
gem 'whenever', '0.9.4', :require => false

# Active Job
gem 'resque', '1.25.2'
gem 'resque-scheduler', '4.0.0'

# Active Record
gem 'squeel', '1.2.3'

# Send Rails variables to JS
gem 'gon', '5.2.3'

# Admin Page
gem 'activeadmin', github: 'activeadmin'

# gem 'mailcatcher'
gem 'google-analytics-rails'

#paypal payment
gem 'activemerchant'

# dotenv
gem 'dotenv-rails'

#date Validate
gem 'date_validator', '~> 0.7.0'
gem 'fullcalendar-rails'
gem 'momentjs-rails', '~> 2.9', :github => 'derekprior/momentjs-rails'

# videojs
gem 'video-js-rails'

#
gem 'aws-sdk', '~>2'

#country select
gem 'country_select'

#soft-delete
gem 'kakurenbo-puti'

# Role
gem 'cancancan', '~> 1.10'

#taggable
gem 'acts-as-taggable-on'

# Chartjs
gem 'chart-js-rails'

# jQuery File Uploads
gem 'remotipart', '~> 1.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '4.0.3'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '1.3.3'
  gem "spring-commands-rspec", '1.0.4'

  # guard
  gem 'guard', '2.12.5'
  gem 'terminal-notifier-guard', '1.6.4'

  # test framework
  gem 'rspec-rails', '3.2.1'
  gem 'factory_girl_rails', '4.5.0'
  gem 'database_rewinder', '0.5.1'
  gem 'faker', '1.4.3'
  gem 'rspec-power_assert', '0.2.0'
  gem 'rspec-parameterized', '0.1.3'
  gem "shoulda-matchers", '2.8.0'
  #gem 'webmock'
  gem 'timecop', '0.7.3'
  gem 'guard-rspec', '4.5.0', require: false

  # ruby code checker
  gem 'rubocop', '0.29.1'
  gem 'guard-rubocop', '1.2.0'

  # livereload
  gem 'guard-livereload', '2.4.0', require: false

  # make ER map
  gem "rails-erd", '1.3.1'

  # good to read error screen
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'

  # check unuseful sql
  gem 'bullet', '4.14.4'

  # tells me rails best practice
  gem 'rails_best_practices', '1.15.7'

  # Pry
  gem 'pry-rails', '0.3.3'
  gem 'pry-coolline', '0.2.5'
  gem 'pry-byebug', '3.1.0'
  gem 'pry-doc', '0.6.0'
  gem 'pry-stack_explorer', '0.4.9.2'
  gem 'awesome_print', '1.6.1'

  # nice show of sql result
  gem 'hirb', '0.7.3'
  gem 'hirb-unicode', '0.0.5'

  # Show Partial Block as Comment-out
  gem "view_source_map", '0.1.0'
end

group :production, :staging, :develop do
  gem 'rails_12factor', '0.0.3' # for heroku

  # for cache
  gem "memcachier", '0.0.2' # for heroku
  gem 'dalli', '2.7.4'
  gem 'rack-cache', '1.2'
  gem 'kgio', '2.9.3'
end

# Goatmail

[![Gem Version](https://badge.fury.io/rb/goatmail.svg)](http://badge.fury.io/rb/goatmail)
[![Build Status](https://travis-ci.org/tyabe/goatmail.svg)](https://travis-ci.org/tyabe/goatmail)
[![Coverage Status](https://img.shields.io/coveralls/tyabe/goatmail.svg)](https://coveralls.io/r/tyabe/goatmail?branch=master)
[![Code Climate](https://codeclimate.com/github/tyabe/goatmail/badges/gpa.svg)](https://codeclimate.com/github/tyabe/goatmail)
[![Dependency Status](https://gemnasium.com/tyabe/goatmail.svg)](https://gemnasium.com/tyabe/goatmail)

A Sinatra-based frontend to the [letter_opener](https://github.com/ryanb/letter_opener).  
This provides almost the same feature as the [letter_opener_web](https://github.com/fgrehm/letter_opener_web).  
letter_opener_web is Rails based application. It's very useful.
But, I wanted a more simple application.

Try it out in [https://goatmail.herokuapp.com/](https://goatmail.herokuapp.com/).

## Installation

First add the gem to your development environment and run the bundle command to install it.

    gem 'goatmail', :group => :development

## Rails Setup

Then set the delivery method in `config/environments/development.rb`

```ruby
  # If you will specify a message file location.
  # Goatmail.location = Rails.root.join('tmp/goatmail')
  config.action_mailer.delivery_method = :goatmail
```

And mount app, add to your routes.rb

```ruby
Sample::Application.routes.draw do
  if Rails.env.development?
    mount Goatmail::App, at: "/inbox"
  end
end
```

If you use the Rails 5, Please use a combination with the Sinatra 2.0 later version.

## Padrino Setup

Then set the delivery method and mount app in `config/apps.rb`

```ruby
Padrino.configure_apps do
  if Padrino.env == :development
    # If you will specify a message file location.
    # Goatmail.location = Padrino.root('tmp/goatmail')
    set :delivery_method, Goatmail::DeliveryMethod => {}
  end
end

if Padrino.env == :development
  Padrino.mount('Goatmail::App').to('/inbox')
end
Padrino.mount('SampleProject::App', :app_file => Padrino.root('app/app.rb')).to('/')
```

If an exception occurs that "Gem Load Error is: undefined method 'version' for Padrino:Module", please try this:

```ruby
# Gemfile
gem 'goatmail', :group => :development, :require => false

# config/boot.rb
Padrino.before_load do
  require 'goatmail'
end
```


## Sinatra Sample

```ruby
# app.rb
module Sample
  class App < Sinatra::Base
    configure do
      set :root, File.dirname(__FILE__)
      if ENV['RACK_ENV'] == 'development'
        Goatmail.location = File.join("#{root}/tmp/goatmail")
        Mail.defaults do
          delivery_method Goatmail::DeliveryMethod
        end
      end
    end
  end
end
```

```ruby
# config.ru
map '/' do
  run Sample::App.new
end

if ENV['RACK_ENV'] == 'development'
  map '/inbox' do
    run Goatmail::App.new
  end
end
```

See: [Sample Applications](https://github.com/tyabe/goatmail_sample)

## Contributing

1. Fork it ( https://github.com/tyabe/goatmail/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

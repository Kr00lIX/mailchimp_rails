# Mailchimp

* Сontroller for web hooks
   NOTE: now support only unsubscribe hook

Легкая конфигурация переменных

Обзерверы пользователя
колбэки


## Installation

Add this line to your application's Gemfile:
    gem 'mailchimp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mailchimp

## Rails 3 Configuration:
    rails generate mailhimp:install

This will generate the initializer file.

## Usage

Declare mailchimp_user on your user model:
    class User < ActiveRecord::Base

      mailchimp_user do |user|
        # describe mailchimp's params
        {
          EMAIL: user.email,
          NAME: user.full_name
        }
      end

    end

Add Mailchimp web hooks routes:

    Site::Application.routes do
      match 'api/unsubscribe' => Mailchimp.routes
    end

and add `http://{site_hostname}/api/unsubscribe` url to mailchimp webhooks panel



## Caveats

## Useful Links
- [Mailchimp API 1.3](http://apidocs.mailchimp.com/api/1.3/index.php)
- [Hominid (wrapper for Mailchimp API)](https://github.com/terra-firma/hominid)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


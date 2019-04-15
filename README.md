# Intellimesh

Task, worker, and service fabric for IdeaCrew applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'intellimesh'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install intellimesh

## Sneakers ActiveJob Worker Installation

Generate your ActiveJob workers as normal.

You can produce the runner script which will host the workers under sneakers using:

```
bundle exec rails g intellimesh:sneakers_active_job_host
```

It will be created using Diplomat as the default configuration provider.  Be sure to read it to understand the required environment variables.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

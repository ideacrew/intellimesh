# Intellimesh

Task, worker, and service fabric for IdeaCrew applications.

Broker: 
Producer: an application that sends messages to an Exchange on a Broker
Consumer: an application that consumes messages from a Queue on the Broker and invokes the Processors to act upon the messages

Message: an event or command sent via Broker. Messages include both header and payload components.
Exchange: in RabbitMQ's model, producers send messages to an Exchange. Consumers can create a Queue that listens to the exchange, instead of subscribing to the exchange directly. This is done so that the queue can buffer any messages and we can make sure all messages get delivered to the consumer.
Queue: a queue listens to an Exchange. In most cases the queue will listen to all messages, but it's also possible to listen to a specific pattern.
Routing Key: a pattern string that enables queues to filter messages on an Exchange
Processor: the specific class that processes a message.


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

# OpenAI Toolable

`openai-toolable` is a Ruby gem that extends the official `openai` gem to provide a simple and flexible way to use tools with the OpenAI API. It allows you to define tools, including their names, descriptions, and parameters, and then easily integrate them into your chat completion requests.

This gem is built on top of the `openai-ruby` gem and is designed to be a lightweight and intuitive extension for developers who want to leverage function calling in their Ruby applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'openai-toolable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install openai-toolable

## Usage

Here's a simple example of how to use `openai-toolable` to define a tool and use it with the OpenAI API:

```ruby
require "openai/toolable"

# Define a tool
weather_tool = Openai::Toolable::ToolFactory.build(
  name: "get_weather",
  description: "Get the current weather in a given location",
  parameters: [
    { name: "location", type: :string, description: "The city and state, e.g. San Francisco, CA" },
    { name: "unit", type: :string, description: "The unit of temperature, e.g. celsius or fahrenheit" }
  ]
)

# Create a tool handler and register the tool
tool_handler = Openai::Toolable::ToolHandler.new
tool_handler.register(
  name: "get_weather",
  lambda: ->(location:, unit:) { puts "Getting the weather in #{location} (#{unit})..." }
)

# Create a client
client = OpenAI::Client.new

# Create a chat completion
response = client.chat(
  parameters: {
    model: "gpt-3.5-turbo",
    messages: [{ role: "user", content: "What's the weather like in Boston?" }],
    tools: [weather_tool.to_json]
  }
)

# Handle the response
tool_handler.handle(response: response)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vancuren/openai-toolable.

## Acknowledgments

This gem is an extension of the official `openai-ruby` gem. We are grateful to the maintainers of the `openai-ruby` for their excellent work.

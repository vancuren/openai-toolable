# OpenAI Toolable

[![Gem Version](https://badge.fury.io/rb/openai-toolable.svg)](https://badge.fury.io/rb/openai-toolable)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Downloads](https://img.shields.io/gem/dt/openai-toolable.svg)](https://rubygems.org/gems/openai-toolable)


`openai-toolable` is a Ruby gem that extends the official `openai` gem to provide a simple and flexible way to use tools with the OpenAI API. It allows you to define tools, including their names, descriptions, and parameters, and then easily integrate them into your chat completion requests.

This gem is built on top of the `openai-ruby` gem and is designed to be a lightweight and intuitive extension for developers who want to leverage function calling in their Ruby applications.

## Features

- **Easy tool definition**: Define tools with parameters, types, and descriptions
- **Automatic parameter validation**: Mark parameters as required to ensure they're included
- **Response handling**: Automatically parse and execute tool calls from OpenAI responses
- **Backward compatibility**: Works with both hash responses and OpenAI client response objects
- **Type safety**: Proper parameter type conversion and validation

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
require "openai"

# Set your API key
OPENAI_API_KEY = ENV["OPENAI_API_KEY"]

# Define a tool with required parameters
weather_tool = Openai::Toolable::ToolFactory.build(
  name: "get_weather",
  type: "function",
  description: "Get the current weather in a given location",
  parameters: [
    { name: "location", type: :string, description: "The city and state, e.g. San Francisco, CA", required: true },
    { name: "unit", type: :string, description: "The unit of temperature, e.g. celsius or fahrenheit", required: true }
  ]
)

# Create a tool handler and register the tool
tool_handler = Openai::Toolable::ToolHandler.new
tool_handler.register(
  name: "get_weather",
  lambda: ->(location:, unit:) { puts "Getting the weather in #{location} (#{unit})..." }
)

# Create a client
client = OpenAI::Client.new(api_key: OPENAI_API_KEY)

begin
  # Create a chat completion
  response = client.chat.completions.create(
    model: "gpt-4o-mini",
    messages: [{ role: "user", content: "What's the weather like in Boston?" }],
    tools: [weather_tool.to_json],
    tool_choice: "auto"
  )

  # Handle the response
  tool_handler.handle(response: response)
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end
```

## Parameter Configuration

Parameters can be configured with the following options:

- `name`: The parameter name (required)
- `type`: The parameter type (`:string`, `:number`, `:boolean`, etc.)
- `description`: A description of what the parameter is for
- `required`: Whether the parameter is required (default: `false`)

```ruby
parameters: [
  { 
    name: "location", 
    type: :string, 
    description: "The city and state, e.g. San Francisco, CA", 
    required: true 
  },
  { 
    name: "unit", 
    type: :string, 
    description: "celsius or fahrenheit", 
    required: false 
  }
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vancuren/openai-toolable.

## Acknowledgments

This gem is an extension of the official `openai-ruby` gem. We are grateful to the maintainers of the `openai-ruby` for their excellent work.

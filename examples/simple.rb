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

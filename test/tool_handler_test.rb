require "minitest/autorun"
require "openai/toolable"

class ToolHandlerTest < Minitest::Test
  def test_tool_handler
    tool_handler = Openai::Toolable::ToolHandler.new
    tool_handler.register(
      name: "get_weather",
      lambda: ->(location:, unit:) { "Getting the weather in #{location} (#{unit})..." }
    )

    response = {
      "choices" => [
        {
          "message" => {
            "tool_calls" => [
              {
                "function" => {
                  "name" => "get_weather",
                  "arguments" => "{\"location\":\"Boston\",\"unit\":\"fahrenheit\"}"
                }
              }
            ]
          }
        }
      ]
    }

    result = tool_handler.handle(response: response)

    assert_equal "Getting the weather in Boston (fahrenheit)...", result
  end
end

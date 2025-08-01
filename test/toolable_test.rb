require "minitest/autorun"
require "openai/toolable"

class ToolableTest < Minitest::Test
  def test_tool_creation
    tool = Openai::Toolable::ToolFactory.build(
      name: "get_weather",
      description: "Get the current weather in a given location",
      parameters: [
        { name: "location", type: :string, description: "The city and state, e.g. San Francisco, CA" },
        { name: "unit", type: :string, description: "The unit of temperature, e.g. celsius or fahrenheit" }
      ]
    )

    expected_json = {
      type: "function",
      function: {
        name: "get_weather",
        description: "Get the current weather in a given location",
        parameters: {
          type: :object,
          properties: {
            "location" => { type: :string, description: "The city and state, e.g. San Francisco, CA" },
            "unit" => { type: :string, description: "The unit of temperature, e.g. celsius or fahrenheit" }
          },
          required: []
        }
      }
    }

    assert_equal expected_json, tool.to_json
  end
end

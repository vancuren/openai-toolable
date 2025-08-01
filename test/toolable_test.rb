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

    assert_equal "get_weather", tool.name
    assert_equal "Get the current weather in a given location", tool.description
    assert_equal 2, tool.parameters.length
    assert_instance_of Openai::Toolable::Parameter, tool.parameters.first
  end
end

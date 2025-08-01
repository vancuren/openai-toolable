require "json"

module Openai
  module Toolable
    class ToolHandler
      def initialize
        @tools = {}
      end

      def register(name:, lambda:)
        @tools[name] = lambda
      end

      def handle(response:)
        tool_call = response.dig("choices", 0, "message", "tool_calls", 0)
        return unless tool_call

        function_name = tool_call.dig("function", "name")
        arguments = JSON.parse(tool_call.dig("function", "arguments"))

        @tools[function_name]&.call(**arguments.transform_keys(&:to_sym))
      end
    end
  end
end

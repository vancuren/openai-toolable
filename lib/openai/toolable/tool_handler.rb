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
        # Handle both hash responses and OpenAI client response objects
        if response.respond_to?(:choices)
          # OpenAI client response object
          tool_calls = response.choices[0]&.message&.tool_calls
          return unless tool_calls && !tool_calls.empty?
          
          tool_call = tool_calls[0]
          function_name = tool_call.function.name
          arguments = JSON.parse(tool_call.function.arguments)
        else
          # Hash response (backward compatibility)
          tool_call = response.dig("choices", 0, "message", "tool_calls", 0)
          return unless tool_call

          function_name = tool_call.dig("function", "name")
          arguments = JSON.parse(tool_call.dig("function", "arguments"))
        end

        @tools[function_name]&.call(**arguments.transform_keys(&:to_sym))
      end
    end
  end
end

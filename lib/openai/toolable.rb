require_relative "toolable/version"
require_relative "toolable/parameter"
require_relative "toolable/tool_handler"

module Openai
  module Toolable
    class Error < StandardError; end
    
    class Tool
      attr_reader :name, :description, :parameters

      def initialize(name:, description:, parameters: [])
        @name = name
        @description = description
        @parameters = parameters.map do |param|
          Parameter.new(
            name: param[:name],
            type: param[:type],
            description: param[:description],
            required: param.fetch(:required, false)
          )
        end
      end

      def to_json
        {
          name: name,
          description: description,
          parameters: {
            type: :object,
            properties: parameters.each_with_object({}) do |param, hash|
            hash[param.name] = { type: param.type, description: param.description }
          end,
          required: parameters.select(&:required).map(&:name)
          }
        }
      end
    end

    class ToolFactory
      def self.build(name:, description:, parameters: [])
        Tool.new(name: name, description: description, parameters: parameters)
      end
    end
  end
end
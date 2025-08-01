require_relative "toolable/version"
require_relative "toolable/parameter"
require_relative "toolable/tool_handler"

module Openai
  module Toolable
    class Error < StandardError; end
    
    class Tool
      attr_reader :name, :description, :parameters, :type

      def initialize(name:, description:, parameters: [], type: "function")
        @name = name
        @type = type
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
          "type" => @type,
          "function" => {
            "name" => @name,
            "description" => @description,
            "parameters" => {
              "type" => "object",
              "properties" => @parameters.each_with_object({}) do |param, hash|
                hash[param.name.to_s] = { "type" => param.type.to_s, "description" => param.description }
              end,
              "required" => @parameters.select(&:required).map { |p| p.name.to_s }
            }
          }
        }
      end
    end

    class ToolFactory
      def self.build(name:, description:, parameters: [], type: "function")
        Tool.new(name: name, description: description, parameters: parameters, type: type)
      end
    end
  end
end
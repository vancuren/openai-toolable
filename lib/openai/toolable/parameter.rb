module Openai
  module Toolable
    class Parameter
      attr_reader :name, :type, :description, :required

      def initialize(name:, type:, description:, required: false)
        @name = name
        @type = type
        @description = description
        @required = required
      end
    end
  end
end

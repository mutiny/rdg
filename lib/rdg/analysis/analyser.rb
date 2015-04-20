require_relative "context"
require_relative "registry"

module RDG
  module Analysis
    class Analyser
      def self.register_analyser(*types)
        Registry.register_by_type(self, *types)
      end

      def self.register_default_analyser
        Registry.register_default(self)
      end

      def initialize(ast_node, context = Context.new)
        @ast_node, @context = ast_node, context
        prepare
      end

      def analyse
      end

      private

      def prepare
      end

      def graph
        @context.graph
      end

      def equivalences
        @context.equivalences
      end

      def registry
        @context.registry
      end
    end
  end
end

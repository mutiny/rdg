require_relative "context"
require_relative "registry"

module RDG
  module Analysis
    class Analyser
      extend Forwardable
      def_delegators :@context, :graph, :equivalences, :registry

      def self.register_analyser(*types)
        Registry.register_by_type(self, *types)
      end

      def self.register_default_analyser
        Registry.register_default(self)
      end

      def initialize(ast_node)
        @ast_node = ast_node
        prepare
      end

      def analyse(context = Context.new)
        @context = context
      end

      private

      def prepare
        # do nothing
      end

      def remove_all_successors
        graph.each_successor(@ast_node) { |s| graph.remove_edge(@ast_node, s) }
      end
    end
  end
end

module RDG
  module Control
    class Return < Analyser
      register_analyser :return

      def initialize(ast_node, graph, state)
        @graph, @ast_node, @state = graph, ast_node, state
      end

      def analyse
        return unless @state.key?(:current_method)
        @graph.each_successor(@ast_node) { |s| @graph.remove_edge(@ast_node, s) }
      end
    end
  end
end

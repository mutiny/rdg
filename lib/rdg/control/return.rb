module RDG
  module Control
    class Return < Analyser
      register_analyser :return

      def initialize(ast_node, graph)
        @graph, @ast_node = graph, ast_node
      end

      def analyse
        @graph.each_successor(@ast_node) { |s| @graph.remove_edge(@ast_node, s) }
      end
    end
  end
end

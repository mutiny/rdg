module RDG
  module Control
    class Return < Analyser
      register_analyser :return

      def analyse
        super
        @graph.each_successor(@ast_node) { |s| @graph.remove_edge(@ast_node, s) }
      end
    end
  end
end

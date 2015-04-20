require "rdg/analysis/analyser"

module RDG
  module Control
    class Return < Analysis::Analyser
      register_analyser :return

      def analyse
        graph.each_successor(@ast_node) { |s| graph.remove_edge(@ast_node, s) }
      end
    end
  end
end

require_relative "analyser"

module RDG
  module Control
    class Retry < Analyser
      register_analyser :retry

      def analyse
        return unless block
        remove_all_successors
        add_first_child_as_successor
      end

      private

      def remove_all_successors
        @graph.each_successor(@ast_node) { |s| @graph.remove_edge(@ast_node, s) }
      end

      def add_first_child_as_successor
        @graph.add_edge(@ast_node, first_child_of_block)
      end

      def first_child_of_block
        @equivalences.find(block.children.first)
      end

      def block
        @ast_node.ancestors.detect { |a| %i(rescue).include?(a.type) }
      end
    end
  end
end

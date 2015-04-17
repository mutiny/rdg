require_relative "jump"

module RDG
  module Control
    class Break < Jump
      register_analyser :break

      def new_successors
        @graph
          .each_successor(test)
          .reject { |s| @ast_node.siblings.include?(s) }
      end

      def test
        @equivalences.first(block.children.first)
      end
    end
  end
end

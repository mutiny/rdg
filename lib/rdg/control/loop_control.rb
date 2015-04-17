require_relative "analyser"

module RDG
  module Control
    class LoopControl < Analyser
      register_analyser :break, :next, :redo

      def analyse
        return unless loop

        remove_all_successors

        if (@ast_node.type == :break)
          successors.each { |s| @graph.add_edge(@ast_node, s) }
        else
          @graph.add_edge(@ast_node, test)
        end
      end

      private

      def remove_all_successors
        @graph.each_successor(@ast_node) { |s| @graph.remove_edge(@ast_node, s) }
      end

      def successors
        @graph
          .each_successor(test)
          .reject { |s| @ast_node.siblings.include?(s) }
      end

      def test
        @equivalences.first(loop.children.first)
      end

      def loop
        @ast_node.ancestors.detect { |a| %i(while until for).include?(a.type) }
      end
    end
  end
end

require_relative "analyser"

module RDG
  module Control
    class LoopControl < Analyser
      register_analyser :break, :next, :redo

      def analyse
        return unless loop

        if (@ast_node.type == :break)
          successors.each { |s| @graph.add_edge(@ast_node, s) }
        else
          @graph.add_edge(@ast_node, test)
        end
      end

      private

      def successors
        @graph
          .each_successor(test)
          .reject { |s| @ast_node.siblings.include?(s) }
      end

      def test
        loop.children.first
      end

      def loop
        @ast_node.ancestors.detect { |a| %i(while until for).include?(a.type) }
      end
    end
  end
end

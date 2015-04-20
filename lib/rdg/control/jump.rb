require "rdg/analysis/analyser"

module RDG
  module Control
    class Jump < Analysis::Analyser
      def analyse
        return unless block
        remove_all_successors
        add_new_successors
      end

      protected

      def block_types
        %i(while until for)
      end

      private

      def remove_all_successors
        graph.each_successor(@ast_node) { |s| graph.remove_edge(@ast_node, s) }
      end

      def add_new_successors
        new_successors.each { |s| graph.add_edge(@ast_node, s) }
      end

      def block
        @ast_node.ancestors.detect { |a| block_types.include?(a.type) }
      end
    end
  end
end

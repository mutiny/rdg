require "rdg/analysis/analyser"

module RDG
  module Control
    class Jump < Analysis::Analyser
      def analyse(context)
        return unless block
        super
        remove_all_successors
        add_new_successors
      end

      protected

      def block_types
        %i(while until for)
      end

      private

      def add_new_successors
        new_successors.each { |s| graph.add_edge(@ast_node, s) }
      end

      def block
        @ast_node.ancestors.detect { |a| block_types.include?(a.type) }
      end
    end
  end
end

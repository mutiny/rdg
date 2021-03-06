require "rdg/analysis/analyser"

module RDG
  module Control
    class Handler < Analysis::Analyser
      def analyse(context)
        super
        add_an_edge_from_every_main_node_to_the_handler
      end

      private

      def add_an_edge_from_every_main_node_to_the_handler
        main.each { |m| graph.add_edge(m, @ast_node) }
      end

      def main
        equivalences.all(block.children.first)
      end

      def block
        @ast_node.parent
      end
    end
  end
end

require_relative "analyser"

module RDG
  module Control
    class RescueBody < Analyser
      register_analyser :resbody

      def analyse
        add_edge_from_every_rescuable_node_to_handler
        super
      end

      def prepare
        _exception_types, _variable_name, *@statements = children
      end

      def internal_flow_edges
        @statements.each_cons(2).to_a
      end

      def start_node
        @statements.first
      end

      def end_nodes
        @statements.last(1)
      end

      def nodes
        @statements
      end

      def add_edge_from_every_rescuable_node_to_handler
        main.each { |m| @graph.add_edge(m, @ast_node) }
      end

      private

      def main
        @equivalences.all(rescue_block.children.first)
      end

      def rescue_block
        @ast_node.ancestors.detect { |a| a.type == :rescue }
      end
    end
  end
end

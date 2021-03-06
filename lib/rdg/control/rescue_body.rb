require "rdg/analysis/propagater"

module RDG
  module Control
    class RescueBody < Analysis::Propagater
      register_analyser :resbody

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
    end
  end
end

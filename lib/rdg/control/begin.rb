require_relative "propagater"

module RDG
  module Control
    class Begin < Propagater
      register_analyser :begin, :kwbegin

      def internal_flow_edges
        children.each_cons(2).to_a
      end

      def start_node
        children.first
      end

      def end_nodes
        children.last(1)
      end
    end
  end
end

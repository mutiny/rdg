module RDG
  module Control
    class Def < Analyser
      register_analyser :def

      def prepare
        _name, _args, @body = children
      end

      def internal_flow_edges
        []
      end

      def start_nodes
        [@body]
      end

      def end_nodes
        [@body]
      end
    end
  end
end

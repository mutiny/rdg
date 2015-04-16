module RDG
  module Control
    class Def < Analyser
      register_analyser :def

      def initialize(ast_node, graph)
        super(ast_node, graph)
        _name, _args, @body = ast_node.children
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

module RDG
  module Control
    class Def < Analyser
      register_analyser :def

      def initialize(ast_node, graph)
        super(ast_node, graph)
        @name, @args, @body = ast_node.children
      end

      def analyse
        @graph.add_edge(@name, @body)
      end
    end
  end
end

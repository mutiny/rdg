module RDG
  module Control
    class Registry
      BY_TYPE = {}

      def self.register_by_type(analyser, *types)
        types.each { |type| BY_TYPE[type] = analyser }
      end

      def self.register_default(analyser)
        BY_TYPE.default = analyser
      end

      def analyser_for(ast_node, context)
        by_node[ast_node].new(ast_node, context)
      end

      def prepend_for(ast_node, analyser)
        by_node[ast_node] = Composite.compose(analyser, by_node[ast_node])
      end

      private

      def by_node
        @by_node ||= Hash.new { |h, node| h[node] = BY_TYPE[node.type] }
      end
    end
  end
end

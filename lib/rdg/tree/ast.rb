require "parser/current"
require_relative "../graph/bidirected_adjacency_graph"
require_relative "rgl/pre_order_iterator"
require_relative "rgl/post_order_iterator"

module RDG
  module Tree
    class AST
      def self.from_path(path, parser = Parser::CurrentRuby)
        from_source(File.read(path), parser)
      end

      def self.from_source(source, parser = Parser::CurrentRuby)
        new(parser.parse(source))
      end

      def initialize(ast)
        @graph = Graph::BidirectedAdjacencyGraph.new
        import(ast)
      end

      def root
        @graph.each_vertex.first
      end

      def pre_order_iterator
        RGL::PreOrderIterator.new(@graph)
      end

      def post_order_iterator
        RGL::PostOrderIterator.new(@graph)
      end

      def write_to_graphic_file(format = 'png', filename = "ast")
        @graph.write_to_graphic_file(format, filename)
      end

      private

      def import(ast)
        Node.new(ast, @graph).tap do |current_node|
          @graph.add_vertex(current_node)

          if ast.respond_to?(:children)
            ast.children.each do |child|
              @graph.add_edge(current_node, import(child))
            end
          end
        end
      end

      class Node
        attr_accessor :wrapped

        def initialize(wrapped, graph)
          @wrapped = wrapped
          @graph = graph
        end

        def compound?
          wrapped.is_a?(Parser::AST::Node)
        end

        def scalar?
          !compound?
        end

        def empty?
          wrapped.nil?
        end

        def type
          compound? ? wrapped.type : nil
        end

        def children
          @graph.each_successor(self).to_a
        end

        def parent
          @graph.each_predecessor(self).first
        end

        def ancestors
          parent.nil? ? [] : parent.ancestors.unshift(parent)
        end

        def siblings
          parent.nil? ? [] : parent.children
        end

        def ==(other)
          if scalar?
            wrapped == other.wrapped
          else
            type == other.type && children == other.children
          end
        end

        def inspect
          to_s
        end

        def to_s
          wrapped.to_s
        end
      end
    end
  end
end

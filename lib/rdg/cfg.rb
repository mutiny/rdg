require "require_all"

require_relative "tree/ast"
require_rel "analysis/*"
require_rel "control/*"

module RDG
  class CFG
    def self.from_path(path)
      new(Tree::AST.from_path(path))
    end

    def self.from_source(source)
      new(Tree::AST.from_source(source))
    end

    def self.from_ast(ast)
      new(Tree::AST.new(ast))
    end

    def initialize(ast)
      @context = Analysis::Context.new
      @context.graph.add_vertex(ast.root)
      analyse(ast)
    end

    def write_to_graphic_file(format = 'png', filename = "cfg")
      @context.graph.write_to_graphic_file(format, filename)
    end

    def vertices
      @context.graph.each_vertex.to_a
    end
    alias_method :nodes, :vertices

    def successors(v)
      @context.graph.each_adjacent(v).to_a
    end

    def edge?(u, v)
      @context.graph.has_edge?(u, v)
    end

    private

    def analyse(ast)
      ast.pre_order_iterator.select(&:compound?).each do |ast_node|
        @context.registry.analyser_for(ast_node).analyse(@context)
      end
    end
  end
end

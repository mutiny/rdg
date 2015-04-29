require "rgl/traversal"

module RDG
  module Tree
    module RGL
      class PostOrderIterator
        include ::RGL::GraphIterator

        def initialize(tree, root = tree.first)
          super(tree)
          @root = root
          set_to_begin
        end

        def set_to_begin
          @visited = Hash.new(false)
          @stack = []
          @start = descend(@root)
          @current = @start
        end

        def at_beginning?
          @current == @start
        end

        def at_end?
          visited?(@root)
        end

        def basic_forward
          @current = descend(@current)
          visit(@current)
          @current
        end

        def basic_backward
          @current = ascend(@current)
          unvisit(@current)
          @current
        end

        private

        def visit(node)
          @visited[node.object_id] = true
        end

        def unvisit(node)
          @visited[node.object_id] = false
        end

        def visited?(node)
          @visited[node.object_id]
        end

        def descend(node)
          next_child = graph.each_adjacent(node).detect { |c| !visited?(c) }

          if visited?(node)
            descend(@stack.pop)
          elsif next_child.nil?
            node
          else
            @stack.push(node)
            descend(next_child)
          end
        end

        def ascend(node)
          last_child = graph.each_adjacent(node).to_a.reverse.detect { |c| visited?(c) }

          if visited?(node)
            node
          elsif last_child.nil?
            ascend(@stack.pop)
          else
            @stack.push(node)
            last_child
          end
        end
      end
    end
  end
end

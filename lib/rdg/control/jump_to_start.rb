require_relative "jump"

module RDG
  module Control
    class JumpToStart < Jump
      def new_successors
        [@equivalences.first(block.children.first)]
      end
    end
  end
end

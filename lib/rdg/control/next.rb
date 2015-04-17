require_relative "jump_to_start"

module RDG
  module Control
    class Next < JumpToStart
      register_analyser :next
    end
  end
end

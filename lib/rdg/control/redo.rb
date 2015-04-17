require_relative "jump_to_start"

module RDG
  module Control
    class Redo < JumpToStart
      register_analyser :redo
    end
  end
end

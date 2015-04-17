require_relative "jump_to_start"

module RDG
  module Control
    class Retry < JumpToStart
      register_analyser :retry

      def block_types
        %i(rescue)
      end
    end
  end
end

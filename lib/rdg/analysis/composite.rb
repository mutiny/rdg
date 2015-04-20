require_relative "analyser"

module RDG
  module Analysis
    class Composite < Analyser
      def self.compose(*ts)
        Class.new(Composite) do
          define_method :types do
            ts
          end
        end
      end

      def initialize(ast_node, context = Context.new)
        @delegates = types.map { |t| t.new(ast_node, context) }
      end

      def analyse
        @delegates.each(&:analyse)
      end
    end
  end
end

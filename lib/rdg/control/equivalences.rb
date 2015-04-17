module RDG
  module Control
    class Equivalences
      def initialize
        @equivalences = {}
      end

      def add(original, result)
        @equivalences[original] = result
      end

      def find(original)
        @equivalences.key?(original) ? find(@equivalences[original]) : original
      end
    end
  end
end

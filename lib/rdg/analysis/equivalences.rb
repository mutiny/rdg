module RDG
  module Analysis
    class Equivalences
      def initialize
        @equivalences = {}
      end

      def add(original, results)
        @equivalences[original] = results
      end

      def all(original)
        if @equivalences.key?(original)
          @equivalences[original].map { |e| all(e) }.flatten
        else
          [original]
        end
      end

      def first(original)
        all(original).first
      end
    end
  end
end

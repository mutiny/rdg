require_relative "analyser"

module RDG
  module Analysis
    class Composite < Analyser
      attr_reader :delegates

      def initialize(*delegates)
        @delegates = delegates
      end

      def analyse(context)
        @delegates.each { |d| d.analyse(context) }
      end
    end
  end
end

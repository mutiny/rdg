require "rdg/analysis/composite"

module RDG
  module Analysis
    describe Composite do
      subject { Composite.compose(FirstAnalyser, SecondAnalyser).new(:node, :context) }

      it "delegates analysis to each composed analyser in turn" do
        subject.analyse

        expect(FirstAnalyser.called).to be_truthy
        expect(SecondAnalyser.called).to be_truthy
      end

      it "makes node available to each composed analyser" do
        subject.analyse

        expect(FirstAnalyser.node).to eq(:node)
        expect(SecondAnalyser.node).to eq(:node)
      end

      it "makes context available to each composed analyser" do
        subject.analyse

        expect(FirstAnalyser.context).to eq(:context)
        expect(SecondAnalyser.context).to eq(:context)
      end
    end

    class FakeAnalyser
      def initialize(node, context)
        self.class.node, self.class.context = node, context
      end

      def analyse
        self.class.called = true
      end

      class << self
        attr_accessor :called, :node, :context
      end
    end

    class FirstAnalyser < FakeAnalyser; end
    class SecondAnalyser < FakeAnalyser; end
  end
end

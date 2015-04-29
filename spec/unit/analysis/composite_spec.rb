require "rdg/analysis/composite"

module RDG
  module Analysis
    describe Composite do
      subject { Composite.new(FirstAnalyser.new(:node), SecondAnalyser.new(:node)) }

      it "delegates analysis to each composed analyser in turn" do
        subject.analyse(:context)

        expect(FirstAnalyser.called).to be_truthy
        expect(SecondAnalyser.called).to be_truthy
      end

      it "makes node available to each composed analyser" do
        subject.analyse(:context)

        expect(FirstAnalyser.node).to eq(:node)
        expect(SecondAnalyser.node).to eq(:node)
      end

      it "makes context available to each composed analyser" do
        subject.analyse(:context)

        expect(FirstAnalyser.context).to eq(:context)
        expect(SecondAnalyser.context).to eq(:context)
      end
    end

    class FakeAnalyser
      def initialize(node)
        self.class.node = node
      end

      def analyse(context)
        self.class.context = context
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

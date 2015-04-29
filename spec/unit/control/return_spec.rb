require "rdg/control/return"
require "rdg/analysis/context"

module RDG
  module Control
    describe Return do
      subject { Return.new(:return) }

      let(:graph) { spy("graph") }
      let(:context) { Analysis::Context.new(graph) }

      it "should remove existing edges out of return node" do
        allow(graph).to receive(:each_successor).and_yield(:successor)

        subject.analyse(context)

        expect(graph).to have_received(:remove_edge).with(:return, :successor)
      end
    end
  end
end

require "rdg/control/return"

module RDG
  module Control
    describe Return do
      let(:graph) { spy("graph") }
      subject { Return.new(:return, graph) }

      it "should remove existing edges out of return node" do
        allow(graph).to receive(:each_successor).and_yield(:successor)

        subject.analyse

        expect(graph).to have_received(:remove_edge).with(:return, :successor)
      end
    end
  end
end

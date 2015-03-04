require "rdg/control/return"

module RDG
  module Control
    describe Return do
      let(:graph) { spy("graph") }
      let(:state) { { current_method: :do_important_stuff } }
      subject { Return.new(:return, graph, state) }

      it "should remove existing edges out of return node" do
        allow(graph).to receive(:each_successor).and_yield(:successor)

        subject.analyse

        expect(graph).to have_received(:remove_edge).with(:return, :successor)
      end

      it "should do nothing if there is no current method" do
        state.delete(:current_method)
        subject.analyse

        expect(graph).not_to have_received(:add_edge)
        expect(graph).not_to have_received(:remove_edge)
      end
    end
  end
end

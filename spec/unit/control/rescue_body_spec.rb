require "rdg/control/rescue_body"

module RDG
  module Control
    describe RescueBody do
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }

      let(:rescue_ast) { FakeAst.new(:rescue, children: [:rescuable]) }
      let(:ast) { FakeAst.new(:resbody, children: [:ts, :e, 1, 2, 3], ancestors: [rescue_ast]) }

      subject { RescueBody.new(ast, graph, equivalences) }

      it "should have control flow start at the first child" do
        expect(subject.start_node).to eq(1)
      end

      it "should have control flow end at the last child" do
        expect(subject.end_nodes).to eq([3])
      end

      it "should have control flow edges between each pair of children" do
        expect(subject.internal_flow_edges).to eq([[1, 2], [2, 3]])
      end

      it "should add edges from main to first child" do
        allow(equivalences).to receive(:all).with(:rescuable).and_return(
          %i(first_rescuable second_rescuable)
        )

        subject.analyse

        expect(graph).to have_received(:add_edge).with(:first_rescuable, ast)
        expect(graph).to have_received(:add_edge).with(:second_rescuable, ast)
      end
    end
  end
end

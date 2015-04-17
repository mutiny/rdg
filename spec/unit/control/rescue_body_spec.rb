require "rdg/control/rescue_body"

module RDG
  module Control
    describe RescueBody do
      let(:ast) { FakeAst.new(:resbody, children: [:ts, :e, 1, 2, 3]) }
      subject { RescueBody.new(ast, nil) }

      it "should have control flow start at the first child" do
        expect(subject.start_node).to eq(1)
      end

      it "should have control flow end at the last child" do
        expect(subject.end_nodes).to eq([3])
      end

      it "should have control flow edges between each pair of children" do
        expect(subject.internal_flow_edges).to eq([[1, 2], [2, 3]])
      end
    end
  end
end

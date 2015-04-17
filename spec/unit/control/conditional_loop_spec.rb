require "rdg/control/conditional_loop"

module RDG
  module Control
    describe ConditionalLoop do
      let(:ast) { FakeAst.new(:while, children: [:predicate, :body]) }
      subject { ConditionalLoop.new(ast, nil) }

      it "should have control flow start at the predicate" do
        expect(subject.start_node).to eq(:predicate)
      end

      it "should have control flow end at the predicate" do
        expect(subject.end_nodes).to eq([:predicate])
      end

      it "should have control flow edges between predicate and body, and vice-versa" do
        expect(subject.internal_flow_edges).to eq([[:predicate, :body], [:body, :predicate]])
      end
    end
  end
end

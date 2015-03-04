require "rdg/control/while"

module RDG
  module Control
    describe While do
      subject do
        ast = double("ast")
        allow(ast).to receive(:children) { [:predicate, :body] }
        While.new(ast, nil, nil)
      end

      it "should have control flow start at the predicate" do
        expect(subject.start_nodes).to eq([:predicate])
      end

      it "should have control flow end at the body" do
        expect(subject.end_nodes).to eq([:body])
      end

      it "should have control flow edges between predicate and body, and vice-versa" do
        expect(subject.internal_flow_edges).to eq([[:predicate, :body], [:body, :predicate]])
      end
    end
  end
end

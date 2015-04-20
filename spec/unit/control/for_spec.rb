require "rdg/control/for"

module RDG
  module Control
    describe For do
      let(:ast) { FakeAst.new(:for, children: [:iterator, :iterable, :body]) }
      subject { For.new(ast) }

      it "should have control flow start at the iterable object" do
        expect(subject.start_node).to eq(:iterable)
      end

      it "should have control flow end at the iterable object" do
        expect(subject.end_nodes).to eq(%i(iterable))
      end

      it "should have control flow edges between iterable and body, and vice-versa" do
        expect(subject.internal_flow_edges).to eq([%i(iterable body), %i(body iterable)])
      end

      it "should have control flow nodes only for iterable and body, and not for iterator" do
        expect(subject.nodes).to eq(%i(iterable body))
      end
    end
  end
end

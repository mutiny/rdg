require "rdg/control/for"

module RDG
  module Control
    describe For do
      let(:ast) { FakeAst.new(:for, children: [:iterator, :iterable, :body]) }
      subject { For.new(ast, nil) }

      it "should have control flow start at the iterable object" do
        expect(subject.start_nodes).to eq([:iterable])
      end

      it "should have control flow end at the iterable object" do
        expect(subject.end_nodes).to eq([:iterable])
      end

      it "should have control flow edges between iterable and body, and vice-versa" do
        expect(subject.internal_flow_edges).to eq([[:iterable, :body], [:body, :iterable]])
      end
    end
  end
end

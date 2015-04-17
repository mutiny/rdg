require "rdg/control/retry"

module RDG
  module Control
    describe Retry do
      let(:graph) { spy("graph") }
      let(:rescue_ast) { FakeAst.new(:rescue, children: [:first, :second]) }
      let(:ast) { FakeAst.new(:retry, ancestors: [rescue_ast]) }
      subject { Retry.new(ast, graph) }

      before(:each) do
        allow(graph).to receive(:each_successor).and_yield(:successor)
      end

      it "should remove any edges to existing successors" do
        subject.analyse

        expect(graph).to have_received(:remove_edge).with(ast, :successor)
      end

      it "should add an edge to the first child of the rescue" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(ast, :first)
      end

      it "should do nothing when not contained within a rescuable block" do
        ast.ancestors = []
        subject.analyse

        expect(graph).not_to have_received(:add_edge)
      end
    end
  end
end

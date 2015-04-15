require "rdg/control/loop_control"

module RDG
  module Control
    describe LoopControl do
      let(:graph) { spy("graph") }
      let(:ast) { double("ast") }
      subject { LoopControl.new(ast, graph) }

      before(:each) do
        loop_ast = double("loop_ast")
        allow(loop_ast).to receive(:type) { :while }
        allow(loop_ast).to receive(:children) { [:test] }

        allow(ast).to receive(:type) { :next }
        allow(ast).to receive(:children) { [:predicate, :body] }
        allow(ast).to receive(:ancestors) { [loop_ast] }
      end

      it "should have add an edge between control expression and containing loop's test" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(ast, :test)
      end
    end
  end
end

require "rdg/control/loop_control"

module RDG
  module Control
    describe LoopControl do
      let(:graph) { spy("graph") }
      let(:loop_ast) { FakeAst.new(:while, children: [:test]) }
      let(:ast) { FakeAst.new(:next, ancestors: [loop_ast]) }
      subject { LoopControl.new(ast, graph) }

      it "should have add an edge between control expression and containing loop's test" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(ast, :test)
      end
    end
  end
end

require "rdg/control/handler"

module RDG
  module Control
    describe Handler do
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }

      let(:block_ast) { FakeAst.new(:rescue, children: [:rescuable]) }
      let(:ast) { FakeAst.new(:resbody, ancestors: [block_ast]) }

      subject { Handler.new(ast, graph, equivalences) }

      it "should add edges from main to handler" do
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

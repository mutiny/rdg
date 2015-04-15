require "rdg/control/def"

module RDG
  module Control
    describe Def do
      let(:graph) { spy("graph") }
      let(:ast) { FakeAst.new(:def, children: [:name, :args, :body]) }
      subject { Def.new(ast, graph) }

      it "should have control flow from name to body" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(:name, :body)
        expect(graph).to have_received(:add_edge).once
      end
    end
  end
end

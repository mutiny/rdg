require "rdg/control/def"

module RDG
  module Control
    describe Def do
      let(:graph) { spy("graph") }
      subject do
        ast = double("ast")
        allow(ast).to receive(:children) { [:name, :args, :body] }
        Def.new(ast, graph)
      end

      it "should have control flow from name to body" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(:name, :body)
        expect(graph).to have_received(:add_edge).once
      end
    end
  end
end

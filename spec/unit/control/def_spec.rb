require "rdg/control/def"

module RDG
  module Control
    describe Def do
      let(:state) { Hash.new }
      let(:graph) { spy("graph") }
      subject do
        ast = double("ast")
        allow(ast).to receive(:children) { [:name, :args, :body] }
        Def.new(ast, graph, state)
      end

      it "should have control flow from name to body" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(:name, :body)
        expect(graph).to have_received(:add_edge).once
      end

      it "should have updated state with name node" do
        subject.analyse

        expect(state[:current_method]).to eq(:name)
      end
    end
  end
end

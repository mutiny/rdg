require "rdg/control/analyser"

module RDG
  module Control
    describe Analyser do
      let(:ast) { double("ast") }
      let(:graph) { spy("graph") }

      subject do
        class DummyAnalyser < Analyser
          def internal_flow_edges
            [[:s1, :e1], [:s2, :e2]]
          end

          def start_nodes
            [:s1, :s2]
          end

          def end_nodes
            [:e1, :e2]
          end
        end

        DummyAnalyser.new(ast, graph)
      end

      it "should add a CFG edge for every internal flow edge" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(:s1, :e1)
        expect(graph).to have_received(:add_edge).with(:s2, :e2)
      end

      it "should move any incoming edges to start nodes" do
        allow(graph).to receive(:each_predecessor).and_yield(:predecessor)

        subject.analyse

        expect(graph).to have_received(:remove_edge).with(:predecessor, ast)
        expect(graph).to have_received(:add_edge).with(:predecessor, :s1)
        expect(graph).to have_received(:add_edge).with(:predecessor, :s2)
      end

      it "should move any outgoing edges to end nodes" do
        allow(graph).to receive(:each_successor).and_yield(:successor)

        subject.analyse

        expect(graph).to have_received(:remove_edge).with(ast, :successor)
        expect(graph).to have_received(:add_edge).with(:e1, :successor)
        expect(graph).to have_received(:add_edge).with(:e2, :successor)
      end

      it "should remove the AST node from the CFG" do
        subject.analyse

        expect(graph).to have_received(:remove_vertex).with(ast)
      end
    end
  end
end

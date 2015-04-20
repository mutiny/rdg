require "rdg/analysis/propagater"

module RDG
  module Analysis
    describe Propagater do
      let(:ast) { FakeAst.new(:some_type) }
      let(:graph) { spy("graph") }
      let(:equivalences) { spy("equivalences") }
      let(:context) { Context.new(graph, equivalences) }

      subject do
        class DummyPropagater < Propagater
          def internal_flow_edges
            [%i(s1 e1), %i(s2 e2)]
          end

          def start_node
            :s1
          end

          def end_nodes
            %i(e1 e2)
          end

          def nodes
            %i(s1 s2 e1 e2)
          end
        end

        DummyPropagater.new(ast, context)
      end

      it "should add a CFG edge for every internal flow edge" do
        subject.analyse

        expect(graph).to have_received(:add_edge).with(:s1, :e1)
        expect(graph).to have_received(:add_edge).with(:s2, :e2)
      end

      it "should move any incoming edges to start node" do
        allow(graph).to receive(:each_predecessor).and_yield(:predecessor)

        subject.analyse

        expect(graph).to have_received(:remove_edge).with(:predecessor, ast)
        expect(graph).to have_received(:add_edge).with(:predecessor, :s1)
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

      it "should add equivalences" do
        subject.analyse

        expect(equivalences).to have_received(:add).with(ast, %i(s1 s2 e1 e2))
      end
    end
  end
end

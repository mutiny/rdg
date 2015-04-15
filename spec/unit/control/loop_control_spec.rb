require "rdg/control/loop_control"

module RDG
  module Control
    describe LoopControl do
      let(:graph) { spy("graph") }
      let(:loop_ast) { FakeAst.new(:while, children: [:test]) }

      context "with break" do
        let(:ast) { FakeAst.new(:break, ancestors: [loop_ast]) }
        subject { LoopControl.new(ast, graph) }

        before(:each) do
          allow(graph).to receive(:each_successor).and_return([:successor, :start_of_loop])
          ast.siblings = [:start_of_loop]
        end

        it "should add an edge between control expression and loop's test's successors" do
          subject.analyse

          expect(graph).to have_received(:add_edge).with(ast, :successor)
        end

        it "shouldn't add an edge between control expression and successor of test within loop" do
          subject.analyse

          expect(graph).not_to have_received(:add_edge).with(ast, :start_of_loop)
        end

        it "should do nothing when not contained within a loop" do
          ast.ancestors = []
          subject.analyse

          expect(graph).not_to have_received(:add_edge)
        end
      end

      %w(next redo).each do |control_type|
        context "with #{control_type}" do
          let(:ast) { FakeAst.new(control_type.to_sym, ancestors: [loop_ast]) }
          subject { LoopControl.new(ast, graph) }

          it "should add an edge between control expression and containing loop's test" do
            subject.analyse

            expect(graph).to have_received(:add_edge).with(ast, :test)
          end

          it "should do nothing when not contained within a loop" do
            ast.ancestors = []
            subject.analyse

            expect(graph).not_to have_received(:add_edge)
          end
        end
      end
    end
  end
end

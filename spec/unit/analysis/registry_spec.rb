require "rdg/analysis/registry"

module RDG
  module Analysis
    describe Registry do
      let(:ast) { FakeAst.new(:if) }

      before(:each) do
        Registry.clear
      end

      it "should allow analysers to be added by type" do
        Registry.register_by_type FakeIfAnalyser, :if
        analyser = subject.analyser_for(ast, :context)

        expect(analyser.class).to eq(FakeIfAnalyser)
      end

      it "should select the correct analyser based on the AST's type" do
        Registry.register_by_type FakeIfAnalyser, :if
        Registry.register_by_type FakeForAnalyser, :for
        analyser = subject.analyser_for(ast, :context)

        expect(analyser.class).to eq(FakeIfAnalyser)
      end

      it "should select the default analyser if the AST's type is not recognised" do
        Registry.register_by_type FakeForAnalyser, :for
        Registry.register_default FakeDefaultAnalyser
        analyser = subject.analyser_for(ast, :context)

        expect(analyser.class).to eq(FakeDefaultAnalyser)
      end

      context "customisation" do
        before(:each) do
          Registry.register_by_type FakeIfAnalyser, :if
          subject.prepend_for(ast, FakeExtraAnalyser)
        end

        it "should allow an additional handler to be prepended for a specific AST node" do
          analyser = subject.analyser_for(ast, :context)

          expect(analyser.class.superclass).to eq(Composite)
          expect(analyser.types).to eq([FakeExtraAnalyser, FakeIfAnalyser])
        end

        it "should not run a prepended analyser for a different AST node of the same type" do
          analyser = subject.analyser_for(FakeAst.new(:if), :context)

          expect(analyser.class).to eq(FakeIfAnalyser)
        end
      end

      class FakeDefaultAnalyser < Analyser; end
      class FakeIfAnalyser < Analyser; end
      class FakeForAnalyser < Analyser; end
      class FakeExtraAnalyser < Analyser; end
    end
  end
end

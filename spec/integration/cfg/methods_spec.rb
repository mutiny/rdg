require "rdg/cfg"

module RDG
  describe CFG do
    context "for a simple method" do
      it "should show control flowing from the method name to the body" do
        cfg = CFG.from_source("def foo; a = 1; a = 2; end")
        name, first, _ = cfg.vertices

        expect(cfg.vertices.size).to eq(3)
        expect(cfg.has_edge?(name, first)).to be_truthy
      end
    end

    context "for a method containing an early return" do
      before(:all) do
        @cfg = CFG.from_source("def foo; a = 1; if a == 2; return; end; a = 2; end")
        @name, @first, _, _, @ret = @cfg.vertices
      end

      it "should show control flowing from the method name to the body" do
        expect(@cfg.has_edge?(@name, @first)).to be_truthy
      end

      it "should not show control flowing from return to successor" do
        expect(@cfg.has_edge?(@ret, @second)).to be_falsey
      end
    end

    context "return from no method" do
      it "should do nothing" do
        cfg = CFG.from_source("return")

        puts cfg.vertices
        expect(cfg.vertices.empty?).to be_truthy
      end
    end
  end
end

require "rdg/cfg"

module RDG
  describe CFG do
    context "for a sequence of statements" do
      it "should show no control flow for a lone integer" do
        cfg = CFG.from_source("1")

        expect(cfg).to contain("1")
      end

      it "should show no control flow for a lone assignment" do
        cfg = CFG.from_source("a = 1")

        expect(cfg).to contain("a = 1")
      end

      it "should show control flowing between children in order" do
        cfg = CFG.from_source("a = 1; b = 2; c = 3")

        expect(cfg).to contain("a = 1", "b = 2", "c = 3")

        expect(cfg).to flow_between("a = 1", "b = 2")
        expect(cfg).to flow_between("b = 2", "c = 3")
      end

      it "should show control flowing into the first child" do
        cfg = CFG.from_source("a = 1; begin; b = 1; b = 2; end")

        expect(cfg).to contain("a = 1", "b = 1", "b = 2")

        expect(cfg).to flow_between("a = 1", "b = 1")
        expect(cfg).to flow_between("b = 1", "b = 2")
      end

      it "should show control flowing out of the last child" do
        cfg = CFG.from_source("begin; b = 1; b = 2; end; b = 3")

        expect(cfg).to contain("b = 1", "b = 2", "b = 3")

        expect(cfg).to flow_between("b = 1", "b = 2")
        expect(cfg).to flow_between("b = 2", "b = 3")
      end
    end
  end
end

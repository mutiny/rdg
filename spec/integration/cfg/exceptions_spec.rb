require "rdg/cfg"

module RDG
  describe CFG do
    context "for an exception handler" do
      it "should show control flow from every child to the start of every handler" do
        cfg = CFG.from_source("begin; a = 1; b = 1; rescue Err; y = 1; rescue; z = 1; end")

        expect(cfg).to contain("a = 1", "b = 1", "y = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "y = 1")
        expect(cfg).to flow_between("b = 1", "y = 1")
        expect(cfg).to flow_between("a = 1", "z = 1")
        expect(cfg).to flow_between("b = 1", "z = 1")
      end

      it "should show control flowing into the first child" do
        cfg = CFG.from_source("a = 1; begin; b = 1; rescue; z = 1; end")

        expect(cfg).to contain("a = 1", "b = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b = 1")
      end

      it "should show control flowing out of the last child and the handlers" do
        cfg = CFG.from_source("begin; a = 1; rescue Err; w = 1; x = 1; rescue; y = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "x = 1", "w  = 1", "y = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "z = 1")
        expect(cfg).to flow_between("x = 1", "z = 1")
        expect(cfg).to flow_between("y = 1", "z = 1")
      end
    end
  end
end

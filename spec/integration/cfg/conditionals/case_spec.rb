require "rdg/cfg"

module RDG
  describe CFG do
    context "for simple case expressions" do
      it "should show control flowing to expression, to test and then through and around action" do
        cfg = CFG.from_source("a = 1; case b; when 2; c = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b", "2", "c = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b")
        expect(cfg).to flow_between("b", "2")
        expect(cfg).to flow_between("2", "z = 1")
        expect(cfg).to flow_between("2", "c = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
      end

      it "should show control flowing through longer action" do
        cfg = CFG.from_source("a = 1; case b; when 2; c = 1; d = 1; e = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b", "2", "c = 1", "d = 1", "e = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b")
        expect(cfg).to flow_between("b", "2")
        expect(cfg).to flow_between("2", "z = 1")
        expect(cfg).to flow_between("2", "c = 1")
        expect(cfg).to flow_between("c = 1", "d = 1")
        expect(cfg).to flow_between("d = 1", "e = 1")
        expect(cfg).to flow_between("e = 1", "z = 1")
      end
    end

    context "for case expressions with several actions" do
      it "should show control flowing from test to action and to alternative" do
        cfg = CFG.from_source("a = 1; case b; when 2; c = 1; else; d = 1; end; z = 1")

        expect(cfg).to contain("a = 1", "b", "2", "c = 1", "d = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b")
        expect(cfg).to flow_between("b", "2")
        expect(cfg).to flow_between("2", "c = 1")
        expect(cfg).to flow_between("2", "d = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
        expect(cfg).to flow_between("d = 1", "z = 1")
      end

      it "should show control flowing from test to action and to next test" do
        cfg = CFG.from_source("a = 1;" \
                              "case b; when 2; c = 1; when 3; d = 1; else; e = 1; end;" \
                              "z = 1")

        expect(cfg).to contain("a = 1", "b", "2", "c = 1", "3", "d = 1", "e = 1", "z = 1")

        expect(cfg).to flow_between("a = 1", "b")
        expect(cfg).to flow_between("b", "2")
        expect(cfg).to flow_between("2", "c = 1")
        expect(cfg).to flow_between("2", "3")
        expect(cfg).to flow_between("3", "d = 1")
        expect(cfg).to flow_between("3", "e = 1")
        expect(cfg).to flow_between("c = 1", "z = 1")
        expect(cfg).to flow_between("d = 1", "z = 1")
        expect(cfg).to flow_between("e = 1", "z = 1")
      end
    end
  end
end

require "rdg/cfg"

module RDG
  describe CFG do
    ["begin"].each do |block_type|
      context "for a #{block_type} block with exception handlers" do
        it "should show control flow from every child to the start of every handler" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1; rescue Err; y = 1; rescue; z = 1; end"
          )

          expect(cfg).to contain("a = 1", "b = 1", "y = 1", "z = 1")

          expect(cfg).to flow_between("a = 1", "y = 1")
          expect(cfg).to flow_between("b = 1", "y = 1")
          expect(cfg).to flow_between("a = 1", "z = 1")
          expect(cfg).to flow_between("b = 1", "z = 1")
        end

        it "should show control flowing into the first child" do
          cfg = CFG.from_source(
            "a = 1; #{block_type}; b = 1; rescue; z = 1; end"
          )

          expect(cfg).to contain("a = 1", "b = 1", "z = 1")

          expect(cfg).to flow_between("a = 1", "b = 1")
        end

        it "should show control flowing out of the last child and the handlers to successor" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1; rescue Err; w = 1; x = 1; rescue; y = 1; end; z = 1"
          )

          expect(cfg).to contain("a = 1", "b = 1", "w = 1", "x = 1", "y = 1", "z = 1")

          expect(cfg).to flow_between("b = 1", "z = 1")
          expect(cfg).to flow_between("x = 1", "z = 1")
          expect(cfg).to flow_between("y = 1", "z = 1")
        end

        it "should show control flowing out from out of last child through an else" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1; rescue Err; w = 1; x = 1; else; y = 1; end; z = 1"
          )

          expect(cfg).to contain("a = 1", "b = 1", "x = 1", "w  = 1", "y = 1", "z = 1")

          expect(cfg).to flow_between("b = 1", "y = 1")
          expect(cfg).to flow_between("y = 1", "z = 1")

          expect(cfg).not_to flow_between("b = 1", "z = 1")
        end
      end

      context "for a #{block_type} with an ensure" do
        it "should show control flow from every child to the start of an ensure" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1; ensure; z = 1; end; final = 1"
          )

          expect(cfg).to contain("a = 1", "b = 1", "z = 1", "final = 1")

          expect(cfg).to flow_between("a = 1", "z = 1")
          expect(cfg).to flow_between("b = 1", "z = 1")

          expect(cfg).to flow_between("z = 1", "final = 1")
          expect(cfg).not_to flow_between("b = 1", "final = 1")
        end

        it "should show control flow from every child incl. rescues to the start of an ensure" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1;" \
            "rescue Err; v = 1;" \
            "rescue; w = 1; y = 1;" \
            "ensure; z = 1; end;" \
            "final = 1"
          )

          expect(cfg).to contain("a = 1", "b = 1", "v = 1", "w = 1", "y = 1", "z = 1", "final = 1")

          expect(cfg).to flow_between("a = 1", "z = 1")
          expect(cfg).to flow_between("b = 1", "z = 1")
          expect(cfg).to flow_between("w = 1", "z = 1")
          expect(cfg).to flow_between("y = 1", "z = 1")

          expect(cfg).to flow_between("z = 1", "final = 1")
          expect(cfg).not_to flow_between("b = 1", "final = 1")
          expect(cfg).not_to flow_between("v = 1", "final = 1")
          expect(cfg).not_to flow_between("y = 1", "final = 1")
        end

        it "should show control flow from last child to ensure via else" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; b = 1;" \
            "rescue; v = 1;" \
            "else; w = 1; y = 1;" \
            "ensure; z = 1; end;" \
            "final = 1"
          )

          expect(cfg).to contain("a = 1", "b = 1", "v = 1", "w = 1", "y = 1", "z = 1", "final = 1")

          expect(cfg).to flow_between("b = 1", "w = 1")
          expect(cfg).to flow_between("y = 1", "z = 1")
          expect(cfg).to flow_between("z = 1", "final = 1")

          # b = 1 could raise, not be rescued and flow directly to ensure
          expect(cfg).to flow_between("b = 1", "z = 1")
          expect(cfg).not_to flow_between("b = 1", "final = 1")
        end
      end

      context "retrying" do
        it "should return control to the start of the #{block_type}" do
          cfg = CFG.from_source(
            "#{block_type}; a = 1; rescue; retry; end; z = 1"
          )

          expect(cfg).to contain("a = 1", "retry", "z = 1")

          expect(cfg).to flow_between("a = 1", "z = 1")
          expect(cfg).to flow_between("a = 1", "retry")
          expect(cfg).to flow_between("retry", "a = 1")

          expect(cfg).not_to flow_between("retry", "z = 1")
        end
      end
    end
  end
end

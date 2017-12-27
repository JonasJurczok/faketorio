describe("Test feature/scenario registration #ingame", function()
    lazy_setup(function()
        require("ingame.functions")
    end)

    it("Should register features correctly", function()
        feature("F1", function()
            scenario("scen1", function()
                print("inside scen 1")
            end)

            scenario("scen2", function()
                print("inside scen 2")
            end)

            scenario("scen3", function()
                print("inside scen 3")
            end)
        end)

        feature("F2", function()
            scenario("scen1", function()
                print("inside scen 1")
            end)

            scenario("scen2", function()
                print("inside scen 2")
            end)

            scenario("scen3", function()
                print("inside scen 3")
            end)
        end)


        local fcount = 0
        local scount = 0

        for name, value in pairs(faketorio.features) do
            fcount = fcount + 1
            for _ in pairs(value) do
                scount = scount + 1
            end
        end

        --require"pl.pretty".dump(features)
        --print("Found " .. fcount .. " features and " .. scount .. " scenarios.")

        assert.are.equals(2, fcount)
        assert.are.equals(6, scount)
    end)
end)

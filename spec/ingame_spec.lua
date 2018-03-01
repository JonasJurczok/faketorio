describe("Test feature/scenario registration #ingame", function()
    lazy_setup(function()
        require("ingame.functions")
        require("faketorio.lib")

    end)

    lazy_teardown(function()
        os.remove("src/control.lua")
        faketorio.clean()
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

        for _, value in pairs(faketorio.features) do
            fcount = fcount + 1
            for _ in pairs(value) do
                scount = scount + 1
            end
        end

        assert.are.equals(2, fcount)
        assert.are.equals(6, scount)
    end)

    it("should execute features correctly.", function()
        faketorio.testcount = 0

        feature("F1", function()
            scenario("S1", function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            scenario("S2", function()
                faketorio.testcount = faketorio.testcount + 1
            end)
        end)

        feature("F2", function()
            scenario("S1", function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            scenario("S2", function()
                faketorio.testcount = faketorio.testcount + 1
            end)
        end)

        faketorio.run()

        assert.are.equals(4, faketorio.testcount)
    end)

end)

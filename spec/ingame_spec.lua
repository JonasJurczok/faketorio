describe("Test feature/scenario registration #ingame", function()
    lazy_setup(function()
        require("ingame.functions")
        require("faketorio.test")

        faketorio.lfs = require("lfs")
        faketorio.delete_dir("target")
        faketorio.lfs.rmdir("target")

    end)

    after_each(function()
        os.remove("src/control.lua")
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

    it("should integrate tests into the mod", function()

        -- copy dummy feature file
        faketorio.output_folder = "target/test"
        assert(faketorio.lfs.mkdir("target"))
        assert(faketorio.lfs.mkdir(faketorio.output_folder))
        assert(faketorio.lfs.mkdir(faketorio.output_folder .. "/faketorio"))
        assert(faketorio.lfs.mkdir(faketorio.output_folder .. "/faketorio/features"))

        faketorio.copy_tests()

        -- create fake control.lua
        local file = io.open(faketorio.output_folder .. "/control.lua", "w")
        file:write("test content")
        file:close()

        faketorio.integrate_tests()

        local control = faketorio.read_file("target/test/control.lua")

        local contentIndex = string.find(control, "test content")
        local runnerIndex = string.find(control, "require%(\"faketorio.core\"%)")
        local featureIndex = string.find(control, "require%(\"faketorio.features.dummy_feature.lua\"%)")
        assert.is_true(contentIndex > 0)
        assert.is_true(runnerIndex > contentIndex)
        assert.is_true(featureIndex > runnerIndex)

        end)
end)

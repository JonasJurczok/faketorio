describe("Test the test command #test", function()
    lazy_setup(function()
        require("faketorio.lib")
        stub(faketorio, "create_map_and_run_factorio")
    end)

    lazy_teardown(function()
        os.remove("spec/busted_feature.lua")
        os.remove("src/control.lua")
        faketorio.clean()
        faketorio.create_map_and_run_factorio:revert()
    end)

    if not busted then busted = {} end

    function busted.collect_file_names(directory)
        local result = {}
        for file in faketorio.lfs.dir(directory) do
            if (file ~= "." and file ~= "..") then
                local path = directory .."/".. file
                local mode = faketorio.lfs.attributes(path, "mode")
                if mode == "file" then
                    table.insert(result, path)
                elseif mode == "directory" then
                    for _, p in pairs(busted.collect_file_names(path)) do
                        table.insert(result, p)
                    end
                end
            end
        end
        table.insert(result, directory)
        return result
    end

    it("should copy all test infra files to the target folder", function()
        local config = io.open(os.getenv("HOME") .. "/.faketorio", "w")
        config:write("faketorio_path = src\n")
        config:write("factorio_mod_path = target\n")
        config:close()

        faketorio.execute({test = true, path = "asd"})

        for _, file in pairs(busted.collect_file_names("src/ingame")) do
            file = string.gsub(file, "src/ingame", "target/Faketorio-test-mod_0.1.0/faketorio")
            print("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        assert.stub(faketorio.create_map_and_run_factorio).was.called_with("asd")
    end)

    it("should copy all tests to the target folder", function()
        local file = io.open("spec/busted_feature.lua", "w")
        file:write("asdasd")
        file:close()

        faketorio.execute({test = true, path = "asd"})

        file = "target/Faketorio-test-mod_0.1.0/faketorio/features/busted_feature.lua"
        assert.is_Truthy(faketorio.lfs.attributes(file))

        file = "target/Faketorio-test-mod_0.1.0/faketorio/features/clean_spec.lua"
        assert.is_Falsy(faketorio.lfs.attributes(file))
    end)

    it("should integrate tests into the mod", function()

        -- create fake control.lua
        local file = io.open("src/control.lua", "w")
        file:write("test content")
        file:close()

        faketorio.execute({test = true})

        local control = faketorio.read_file("target/Faketorio-test-mod_0.1.0/control.lua")

        local contentIndex = string.find(control, "test content")
        local runnerIndex = string.find(control, "require%(\"faketorio.core\"%)")
        local featureIndex = string.find(control, "require%(\"faketorio.features.dummy_feature\"%)")
        assert.is_true(contentIndex > 0)
        assert.is_true(runnerIndex > contentIndex)
        assert.is_true(featureIndex > runnerIndex)

    end)
end)
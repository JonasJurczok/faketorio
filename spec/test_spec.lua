describe("Test the test command #test", function()
    lazy_setup(function()
        require("faketorio.lib")

        faketorio.lfs.mkdir("locale")
        faketorio.lfs.mkdir("locale/de")
        faketorio.lfs.mkdir("locale/en")

        local file = io.open("locale/de/blub.cfg", "w")
        file:write("asdasd")
        file:close()

        file = io.open("locale/en/blub.cfg", "w")
        file:write("asdasd")
        file:close()

        faketorio.assemble()
    end)

    lazy_teardown(function()
        os.remove(".faketorio")
        os.remove("spec/busted_feature.lua")
        faketorio.delete_dir("locale")
        faketorio.clean()
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
        local config = io.open(".faketorio", "w")
        config:write("faketorio_path = src\n")
        config:close()

        faketorio.load_config()
        faketorio.copy_test_infrastructure()

        for _, file in pairs(busted.collect_file_names("src/ingame")) do
            file = string.gsub(file, "src/ingame", "target/Faketorio-test-mod_0.1.0/faketorio")
            print("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end
    end)

    it("should copy all tests to the target folder", function()
        local file = io.open("spec/busted_feature.lua", "w")
        file:write("asdasd")
        file:close()

        faketorio.copy_tests()

        file = "target/Faketorio-test-mod_0.1.0/faketorio/busted_feature.lua"
        assert.is_Truthy(faketorio.lfs.attributes(file))

        file = "target/Faketorio-test-mod_0.1.0/faketorio/clean_spec.lua"
        assert.is_Falsy(faketorio.lfs.attributes(file))
    end)
end)
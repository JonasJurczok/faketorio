describe("Test the copy functionality #copy", function()
    lazy_setup(function()
        require("faketorio.lib")

        faketorio.lfs.mkdir("locale")
        faketorio.lfs.mkdir("locale/de")
        faketorio.lfs.mkdir("locale/en")

        file = io.open("locale/de/blub.cfg", "w")
        file:write("asdasd")
        file:close()

        file = io.open("locale/en/blub.cfg", "w")
        file:write("asdasd")
        file:close()
        stub(faketorio, "load_config")

        faketorio.lfs.mkdir("factorio")
        faketorio.factorio_mod_path = "factorio"
        faketorio.faketorio_path = "src"

    end)

    lazy_teardown(function()
        faketorio.delete_directory("locale")
        faketorio.delete_directory("factorio")
        faketorio.clean()
        faketorio.load_config:revert()
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

    it("should collect all lua scripts with their subfolders from src, spec and locale.", function()
        faketorio.execute({copy = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        for _, file in pairs(busted.collect_file_names("src")) do
            file = string.gsub(file, "src", "factorio/Faketorio-test-mod_0.1.0")
            faketorio.log("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        for _, file in pairs(busted.collect_file_names("locale")) do
            file = "factorio/Faketorio-test-mod_0.1.0/"..file
            faketorio.log("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        file = "factorio/Faketorio-test-mod_0.1.0/faketorio/features/dummy_feature.lua"
        assert.is_Truthy(faketorio.lfs.attributes(file))

        file = "factorio/Faketorio-test-mod_0.1.0/faketorio/features/clean_spec.lua"
        assert.is_Falsy(faketorio.lfs.attributes(file))

        assert.is_Truthy(faketorio.lfs.attributes("factorio/Faketorio-test-mod_0.1.0/info.json"))
    end)

end)
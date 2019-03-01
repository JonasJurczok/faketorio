describe("Test the build functionality #build", function()
    lazy_setup(function()
        require("faketorio.lib")

        faketorio.lfs.mkdir("src/for_test")

        local file = io.open("src/for_test/blub.lua", "w")
        file:write("asdasd")
        file:close()

        faketorio.lfs.mkdir("locale")
        faketorio.lfs.mkdir("locale/de")
        faketorio.lfs.mkdir("locale/en")

        file = io.open("locale/de/blub.cfg", "w")
        file:write("asdasd")
        file:close()

        file = io.open("locale/en/blub.cfg", "w")
        file:write("asdasd")
        file:close()
    end)

    lazy_teardown(function()
        faketorio.delete_directory("locale")
        faketorio.delete_directory("src/for_test")
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

    it("should collect all lua scripts with their subfolders from src and locale.", function()
        faketorio.execute({build = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        for _, file in pairs(busted.collect_file_names("src")) do
            file = string.gsub(file, "src", "target/Faketorio-test-mod_0.1.0")
            faketorio.print_message("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        for _, file in pairs(busted.collect_file_names("locale")) do
            file = "target/Faketorio-test-mod_0.1.0/"..file
            faketorio.print_message("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/info.json"))
    end)

    it("should work without an existing locale folder.", function()
        faketorio.delete_directory("locale")
        faketorio.execute({build = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        for _, file in pairs(busted.collect_file_names("src")) do
            file = string.gsub(file, "src", "target/Faketorio-test-mod_0.1.0")
            faketorio.print_message("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/info.json"))
    end)

    it("should collect thumbnail.png if exists", function()

        local file = io.open("thumbnail.png", "w")
        file:write("asdasd")
        file:close()

        faketorio.execute({build = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/thumbnail.png"))

        os.remove("thumbnail.png")

    end)

    it("should collect changelog.txt if exists", function()

        local file = io.open("changelog.txt", "w")
        file:write("asdasd")
        file:close()

        faketorio.execute({build = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/changelog.txt"))

        os.remove("changelog.txt")

    end)

    it("should include custom files if exists", function()

        local file = io.open("wololo.txt", "w")
        file:write("asdasd")
        file:close()

        faketorio.execute({build = true, config = ".faketorio_with_includes"})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/wololo.txt"))

        os.remove("wololo.txt")
    end)

    it("should fail if custom files don't exist", function()

        local config = {build = true, config = ".faketorio_with_includes"}
        assert.has_error(function() faketorio.execute(config) end)

    end)

end)
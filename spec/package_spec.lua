describe("Test the package functionality #package", function()
    lazy_setup(function()
        require("faketorio.lib")
    end)

    lazy_teardown(function()
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

    it("should create a zipfile with the correct name.", function()
        faketorio.execute({package = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        for _, file in pairs(busted.collect_file_names("src")) do
            file = string.gsub(file, "src", "target/Faketorio-test-mod_0.1.0")
            faketorio.print_message("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/info.json"))

        local attributes = faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0.zip")
        assert.is_Truthy(attributes)
        assert.is_Truthy(attributes.size > 0)
    end)

end)
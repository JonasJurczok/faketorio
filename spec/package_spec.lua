describe("Test the package functionality #package", function()
    lazy_setup(function()
        require("faketorio.lib")
        require("luarocks.core.cfg"):init()
        require("luarocks.fs"):init()
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

    it("should create a zipfile with the correct name [LINUX].", function()
        local cfg = require("luarocks.core.cfg")
        if (cfg.arch:find("win32")) then
            return
        end

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

    it("should create a zipfile with the correct name [WINDOWS].", function()
        local cfg = require("luarocks.core.cfg")
        if (not cfg.arch:find("win32")) then
            return
        end

        stub(os, "execute")
        faketorio.execute({package = true})

        assert.are.equals("target/Faketorio-test-mod_0.1.0", faketorio.output_folder)

        for _, file in pairs(busted.collect_file_names("src")) do
            file = string.gsub(file, "src", "target/Faketorio-test-mod_0.1.0")
            faketorio.print_message("Verifying file ["..file.."].")
            assert.is_Truthy(faketorio.lfs.attributes(file))
        end

        assert.is_Truthy(faketorio.lfs.attributes("target/Faketorio-test-mod_0.1.0/info.json"))

        --assert.stub(os.execute).was.called_with("output", "mod-path/output_name")
        for _,v in ipairs(os.execute.calls) do
            local command = v.vals[1]
            assert.is_Truthy(command:find("7z.exe"))
            assert.is_Truthy(command:find(faketorio.output_name..".zip", 1, true))
            assert.is_Truthy(command:find(faketorio.output_name, 1, true))
            assert.is_Truthy(command:find(faketorio.faketorio_path))
        end
        os.execute:revert()
    end)

end)
describe("Test the helper methods #helper", function()
    setup(function()
        require("faketorio-helper")
    end)

    it("should fail to load config file if not present.", function()
        assert.has_error(function() faketorio.load_config() end)
    end)

    it("should read config if file is present.", function()
        local file = io.open(".faketorio", "w")
        file:write("factorio_run_path = D:\\Spiele\\steamapps\\common\\Factorio\\bin\\x64\\factorio.exe\n")
        file:write("factorio_mod_path = C:\\Users\\jonas\\AppData\\Roaming\\Factorio\\mods\\n")
        file:close()

        faketorio.load_config()

        assert.are.equals("D:\\Spiele\\steamapps\\common\\Factorio\\bin\\x64\\factorio.exe", faketorio.factorio_run_path)
        assert.are.equals("C:\\Users\\jonas\\AppData\\Roaming\\Factorio\\mods", faketorio.factorio_mod_path)

    end)
end)
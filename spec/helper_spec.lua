describe("Test the helper methods #helper", function()
    lazy_setup(function()
        require("faketorio.lib")
    end)

    it("should fail to load config file if not present.", function()
        assert.has_error(function() faketorio.load_config("non-existing") end)
    end)

    it("should read config if file is present.", function()
        faketorio.load_config()

        assert.are.equals("D:\\Spiele\\Factorio\\bin\\x64\\factorio.exe", faketorio.factorio_run_path)
        assert.are.equals("factorio", faketorio.factorio_mod_path)
    end)

    it("delete dir should succeed on non existing directory.", function()
        faketorio.delete_directory("non-existing")
    end)
end)

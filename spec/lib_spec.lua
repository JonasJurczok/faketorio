describe("Test the core library functions #lib", function()
    lazy_setup(function()
        require("faketorio.lib")
    end)

    lazy_teardown(function()
        faketorio.clean()
    end)

    it("should correctly execute commands", function()
        faketorio.output_folder = "output"
        faketorio.factorio_mod_path = "mod-path"
        faketorio.output_name = "output_name"
        faketorio.factorio_run_path = "run-path"

        stub(faketorio, "copy_directory")
        stub(os, "execute")

        faketorio.run("test")

        assert.stub(faketorio.copy_directory).was.called_with("output", "mod-path/output_name")
        assert.stub(os.execute).was.called(2)
    end)
end)
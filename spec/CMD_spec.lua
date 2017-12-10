describe("Faketorio command line usage", function()

    -- TODO: what do I actually want to test here?
    it("should accept the run argument.", function()
        _G.arg = {[0] = "faketorio.lua", "run" }
        require("faketorio")
        faketorio.parse_arguments()
    end)

    it("should accept the build argument.", function()
        _G.arg = {[0] = "faketorio.lua", "build" }
        require("faketorio")
        faketorio.parse_arguments()
    end)

    it("should accept the test argument.", function()
        _G.arg = {[0] = "faketorio.lua", "test" }
        require("faketorio")
        faketorio.parse_arguments()
    end)

    it("should add the execution path to the args table.", function()
        _G.arg = {[0] = "faketorio.lua", "test" }
        require("faketorio")
        local args = faketorio.parse_arguments()

        assert.is_equal(require("lfs").currentdir(), args.path)

    end)
end)
describe("Test mocks #mocks", function()
    lazy_setup(function()
        require("ingame.mocks")
    end)

    before_each(function()
        --stub(faketorio.log, "print")
    end)

    after_each(function()
        --faketorio.log.print:revert()
    end)

    it("should correctly mock a function", function()
        test = {}
        test.get = function()
            return "test"
        end

        assert.are.equals("test", test.get())

        when(test, "get"):then_return("wololo")

        assert.are.equals("wololo", test.get())

        test.get:revert()

        assert.are.equals("test", test.get())
    end)

    it("should fail to mock non existing functions.", function()
        assert.has_errors(function() when(test, "non_existing") end)
    end)

    it("should be possible to have multiple mocks at the same time", function()
        test = {}
        test.get = function()
            return "test"
        end
        test.get2 = function()
            return "test2"
        end

        when(test, "get"):then_return("wololo")
        when(test, "get2"):then_return("asd")

        assert.are.equals("wololo", test.get())
        assert.are.equals("asd", test.get2())

    end)

end)

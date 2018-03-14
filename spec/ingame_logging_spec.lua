describe("Test logging #logging", function()
    lazy_setup(function()
        require("ingame.logging")
    end)

    before_each(function()
        stub(faketorio.log, "print")
    end)

    after_each(function()
        faketorio.log.print:revert()
    end)

    it("should print if the level matches", function()
        local log = faketorio.log

        log.setTrace()
        log.trace("test")
        assert.stub(faketorio.log.print).was_called_with("TRACE: test")

        log.setDebug()
        log.debug("test")
        assert.stub(faketorio.log.print).was_called_with("DEBUG: test")

        log.setInfo()
        log.info("test")
        assert.stub(faketorio.log.print).was_called_with("INFO: test")

        log.setWarn()
        log.warn("test")
        assert.stub(faketorio.log.print).was_called_with("WARN: test")

    end)

    it("should do parameter replacement", function()
        local log = faketorio.log

        log.setDebug()
        log.debug("%s", {"hello"})
        assert.stub(faketorio.log.print).was_called_with("DEBUG: hello")
    end)

    it("should not print if level does not match.", function()
        local log = faketorio.log

        log.setDebug()
        log.trace("test1")
        assert.stub(faketorio.log.print).was_not_called_with("TRACE: test1")

        log.setInfo()
        log.debug("test2")
        assert.stub(faketorio.log.print).was_not_called_with("DEBUG: test2")

        log.setWarn()
        log.info("test3")
        assert.stub(faketorio.log.print).was_not_called_with("INFO: test3")
    end)

    it("should be possible to switch the level on the fly.", function()
        local log = faketorio.log

        log.setTrace()
        log.trace("test1")
        assert.stub(faketorio.log.print).was_called_with("TRACE: test1")

        log.setInfo()
        log.trace("test2")
        assert.stub(faketorio.log.print).was_not_called_with("TRACE: test2")

        log.setTrace()
        log.trace("test3")
        assert.stub(faketorio.log.print).was_called_with("TRACE: test3")
    end)
end)

feature("Test stuff", function()
    scenario("First", function()
        error("failed as well")
    end)

    scenario("Second", function()
        error("failed")
    end)
end)
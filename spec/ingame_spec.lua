describe("Test feature/scenario registration #ingame", function()
    lazy_setup(function()
        require("ingame.functions")
        require("faketorio.lib")
        stub(faketorio, "print")

        _G.defines = {
            mouse_button_type = {
                left = 1
            },
            events = {
                on_gui_click = 2
            }
        }
        _G.game = {}
        game.players = {}
        game.players[1] = {
            name = "asd",
            gui = {
                top = {
                    children = {
                        ["someOtherId"] = {
                            type = "button",
                            name = "someOtherId",
                            children = {}
                        }
                    }
                },
                left = {
                    children = {
                        ["someParent"] = {
                            name = "someParent",
                            children = {
                                {
                                    type = "textfield",
                                    name = "testId",
                                    text = "",
                                    children = {}
                                }
                            }
                        }
                    }
                }
            }
        }

    end)

    lazy_teardown(function()
        faketorio.clean()
        faketorio.print:revert()
    end)

    it("Should register features correctly", function()
        feature("F1", function()
            scenario("scen1", function()
                print("inside scen 1")
            end)

            scenario("scen2", function()
                print("inside scen 2")
            end)

            scenario("scen3", function()
                print("inside scen 3")
            end)
        end)

        feature("F2", function()
            scenario("scen1", function()
                print("inside scen 1")
            end)

            scenario("scen2", function()
                print("inside scen 2")
            end)

            scenario("scen3", function()
                print("inside scen 3")
            end)
        end)


        local fcount = 0
        local scount = 0

        for _, value in pairs(faketorio.features) do
            fcount = fcount + 1
            for _ in pairs(value) do
                scount = scount + 1
            end
        end

        assert.are.equals(2, fcount)
        assert.are.equals(6, scount)
    end)

    it("should execute features correctly.", function()

        faketorio.testcount = 0

        feature("F1", function()
            scenario("S1", function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            scenario("S2", function()
                faketorio.testcount = faketorio.testcount + 1
            end)
        end)

        feature("F2", function()
            scenario("S1", function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            scenario("S2", function()
                faketorio.testcount = faketorio.testcount + 1
            end)
        end)

        faketorio.run()

        assert.are.equals(4, faketorio.testcount)
    end)

    it("should collect failures correctly.", function()
        feature("F1", function()
            scenario("S1", function()
                -- success
            end)

        end)

        feature("F2", function()
            scenario("S1", function()
                error("Failure")
            end)

        end)

        faketorio.run()

        assert.are.equals("spec/ingame_spec.lua:137: Failure", faketorio.errors["F2"]["S1"])
    end)

    it("should enable clicking on things", function()
        _G.script = {}

        function script.raise_event(id, event)
            assert.are.equals(defines.events.on_gui_click, id)

            assert.are.equals("testId", event.element.name)
            assert.are.equals("textfield", event.element.type)
            assert.are.equals(1, event.player_index)
            assert.are.equals(defines.mouse_button_type.left, event.button)
            assert.are.equals(false, event.alt)
            assert.are.equals(false, event.control)
            assert.are.equals(false, event.shift)
        end

        faketorio.click("testId")
    end)

    it("should be able to enter text.", function()

        faketorio.enter_text("testId", "wololo")

        local element = faketorio.find_element_by_id("testId", game.players[1])

        assert.are.equals("wololo", element.text)
    end)

    it("should fail to enter text on invalid element type.", function()
        assert.has_errors(function() faketorio.enter_text("someOtherId", "shouldFail") end)
    end)
end)

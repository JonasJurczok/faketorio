describe("Test feature/scenario registration #ingame", function()
    lazy_setup(function()
        require("ingame.core")
        require("ingame.functions")
        require("ingame.logging")
        require("faketorio.lib")
        stub(faketorio.log, "print")

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
                                },
                                {
                                    type = "checkbox",
                                    name = "checkbox",
                                    text = "",
                                    state = false,
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
        faketorio.features = {}
        faketorio.clean()
        faketorio.log.print:revert()
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

        for _, feature in pairs(faketorio.features) do
            fcount = fcount + 1
            for _ in pairs(feature.scenarios) do
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

        assert.is_Truthy(faketorio.errors["F2"]["S1"]:find("ingame_spec.lua:148: Failure"))
    end)

    it("should execute before/after each functions correctly", function()
        faketorio.testcount = 0

        feature("F2", function()
            before_scenario(function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            after_scenario(function()
                faketorio.testcount = faketorio.testcount + 1
            end)

            scenario("S2", function()
                faketorio.testcount = faketorio.testcount + 1
            end)
        end)

        faketorio.run()
        assert.are.equals(3, faketorio.testcount)
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

    it("should find an existing element.", function ()
        local byId = faketorio.find_element_by_id("testId", game.players[1])
        assert.are.equals("testId", byId.name, "find by id failed.")

        local assert_exists = faketorio.assert_element_exists("testId", game.players[1])
        assert.are.equals("testId", assert_exists.name, "assert exists failed.")
    end)

    it("should work for non existing element.", function ()
        local element = faketorio.find_element_by_id("testId222", game.players[1])
        assert.are.equals(nil, element)
    end)

    it("should fail for asserting non existing element.", function ()
        local result, error = pcall(faketorio.assert_element_exists,"testId222", game.players[1])
        assert.False(result)
        assert.is_Truthy(error)
    end)

    it("not exists should succeed for non existing element.", function()
        local result, _ = pcall(faketorio.assert_element_not_exists,"testId222", game.players[1])
        assert.True(result)
    end)

    it("not exists should fail for asserting existing elements.", function ()
        local result, error = pcall(faketorio.assert_element_not_exists,"testId", game.players[1])
        assert.False(result)
        assert.is_Truthy(error)
    end)

    it("should fail to enter text on invalid element type.", function()
        assert.has_errors(function() faketorio.enter_text("someOtherId", "shouldFail") end)
    end)

    it("should be able to check a checkbox", function()
        faketorio.check("checkbox", game.players[1])

        local checkbox = faketorio.find_element_by_id("checkbox", game.players[1])
        assert.True(checkbox.state)
    end)

    it("should be able to uncheck a checkbox", function()
        faketorio.check("checkbox", game.players[1])
        faketorio.uncheck("checkbox", game.players[1])

        local checkbox = faketorio.find_element_by_id("checkbox", game.players[1])
        assert.False(checkbox.state)
    end)

    it("setting state should fail if it is not a checkbox", function()
        local state, error = pcall(faketorio.check, "testId", game.players[1])

        assert.False(state)
        assert.is_Truthy(error)

        state, error = pcall(faketorio.uncheck, "testId", game.players[1])

        assert.False(state)
        assert.is_Truthy(error)
    end)

    it("should be possible to assert checkbox state.", function()
        faketorio.check("checkbox", game.players[1])

        local state, result = pcall(faketorio.assert_checked, "checkbox", game.players[1])
        assert.True(state)
        assert.is_Falsy(result)

        state, result = pcall(faketorio.assert_unchecked, "checkbox", game.players[1])
        assert.False(state)
        assert.is_Truthy(result)

        faketorio.uncheck("checkbox", game.players[1])

        state, result = pcall(faketorio.assert_unchecked, "checkbox", game.players[1])
        assert.True(state)
        assert.is_Falsy(result)

        state, result = pcall(faketorio.assert_checked, "checkbox", game.players[1])
        assert.False(state)
        assert.is_Truthy(result)
    end)

    it("asserting state should fail if it is not a checkbox", function()
        local state, error = pcall(faketorio.assert_checked, "testId", game.players[1])

        assert.False(state)
        assert.is_Truthy(error)

        state, error = pcall(faketorio.assert_unchecked, "testId", game.players[1])

        assert.False(state)
        assert.is_Truthy(error)
    end)

end)

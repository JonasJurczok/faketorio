if not faketorio then faketorio = {} end

function faketorio.click(name, player)
    -- get players
    player = player or game.players[1]

    -- search for element
    local element = faketorio.assert_element_exists(name, player)

    local event = {}
    event.element = element
    event.player_index = 1
    event.button = defines.mouse_button_type.left
    event.alt = false
    event.control = false
    event.shift = false

    script.raise_event(defines.events.on_gui_click, event)
end

function faketorio.enter_text(name, text, player)
    player = player or game.players[1]

    local element = faketorio.assert_element_exists(name, player)

    local error_message = string.format("Element with id [%s] has invalid type [%s].", name, element.type)
    assert(element.type == "textfield" or element.type == "text-box", debug.traceback(error_message))

    element.text = text
end

function faketorio.assert_element_not_exists(name, player)
    local element = faketorio.find_element_by_id(name, player)
    local error = string.format("Element with name [%s] exists for player [%s].", name, player.name)
    assert(element == nil, debug.traceback(error))
end

function faketorio.assert_element_exists(name, player)
    local element = faketorio.find_element_by_id(name, player)
    local error = string.format("Could not find element with id [%s] for player [%s].", name, player.name)
    assert(element ~= nil, debug.traceback(error))
    return element
end

function faketorio.find_element_by_id(name, player)

    player = player or game.players[1]

    faketorio.log.trace("Starting find by id for id [%s] and player [%s].", { name, player.name})
    local guis = {["top"] = player.gui.top,
                  ["left"] = player.gui.left,
                  ["center"] = player.gui.center,
                  ["goal"] = player.gui.goal}

    for gui_name, gui in pairs(guis) do
        faketorio.log.trace("Searching in gui [%s].", { gui_name })
        for _, child in pairs(gui.children) do
            faketorio.log.trace("Searching in gui element [%s/%s].", { gui_name, child.name})
            local element = faketorio.do_find_element_by_id(name, child)
            if (element ~= nil) then
                return element
            end
        end
    end

    return nil
end

function faketorio.do_find_element_by_id(name, element)

    if (element.name == name) then
        faketorio.log.trace("Found element with id [%s].", { name })
        return element
    end

    -- explicitly check for this problem as I do not trust the factorio internals here
    if (element.children == nil) then
        faketorio.log.trace("Element has no children.")
        return nil
    end

    for _, child in ipairs(element.children) do
        faketorio.log.trace("Searching in gui element [%s/%s].", { element.name, child.name})
        local result = faketorio.do_find_element_by_id(name, child)
        if (result ~= nil) then
            return result
        end
    end
end

function faketorio.check(name, player)
    faketorio.set_state(name, player, true)
end

function faketorio.uncheck(name, player)
    faketorio.set_state(name, player, false)
end

function faketorio.set_state(name, player, state)
    player = player or game.players[1]

    local checkbox = faketorio.assert_element_exists(name, player)

    if (checkbox.type ~= "checkbox") then
        local message = string.format("Element [%s] is of type [%s]. Checkbox expected.", checkbox.name, checkbox.type)
        assert(checkbox.type == "checkbox", debug.traceback(message))
    end

    checkbox.state = state
end

function faketorio.assert_checked(name, player)
    faketorio.assert_state(name, player, true)
end

function faketorio.assert_unchecked(name, player)
    faketorio.assert_state(name, player, false)
end

function faketorio.assert_state(name, player, state)
    player = player or game.players[1]

    local checkbox = faketorio.assert_element_exists(name, player)

    if (checkbox.type ~= "checkbox") then
        local message = string.format("Element [%s] is of type [%s]. Checkbox expected.", checkbox.name, checkbox.type)
        assert(checkbox.type == "checkbox", debug.traceback(message))
    end

    local message = string.format("Unexpected checkbox state. Expected [%s] but found [%s]", state, checkbox.state)
    assert(checkbox.state == state, debug.traceback(message))
end

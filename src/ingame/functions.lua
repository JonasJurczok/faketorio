if not faketorio then faketorio = {} end

faketorio.features = {}
faketorio.errors = {}

function faketorio.run()

    local feature_count = faketorio.count(faketorio.features)
    local current_feature = 0
    for feature_name, scenarios in pairs(faketorio.features) do
        current_feature = current_feature + 1
        faketorio.print("Starting Feature [%s] (%s/%s).", { feature_name, current_feature, feature_count})

        local scenario_count = faketorio.count(scenarios)
        local current_scenario = 0
        for scenario_name, scenario in pairs(scenarios) do
            current_scenario = current_scenario + 1
            faketorio.print("Starting Scenario %s (%s/%s).", {scenario_name, current_scenario, scenario_count})

            local status, error = pcall(scenario)
            if (status) then
                faketorio.print("Finished Scenario %s.", {scenario_name})
            else
                faketorio.print("Finished Scenario %s with failure %s.", {scenario_name, error})
                faketorio.error(feature_name, scenario_name, error)
            end
        end

        faketorio.print("Finished Feature %s.", {feature_name})
    end

    faketorio.print_result(feature_count)
end

function faketorio.error(feature, scenario, error)
    if (not faketorio.errors[feature]) then
        faketorio.errors[feature] = {}
    end

    faketorio.errors[feature][scenario] = error
end

function faketorio.print_result(feature_count)

    local error_count = faketorio.count(faketorio.errors)
    if (error_count > 0) then
        faketorio.print("\n\nTESTRUN FINISHED: FAILURE")
    else
        faketorio.print("\n\nTESTRUN FINISHED: SUCCESS")
    end

    faketorio.print("Run contained %s features.", { feature_count })

    if (error_count > 0) then
        faketorio.print("The following errors occured:")
    end
    for feature, scenarios in pairs(faketorio.errors) do
        for scenario, error in pairs(scenarios) do
            faketorio.print("Scenario %s - %s failed with error: %s", {feature, scenario, error})
        end
    end

end

function faketorio.count(list)
    local count = 0
    for _, _ in pairs(list) do
        count = count +1
    end

    return count
end

function faketorio.click(id)
    -- get players
    local player = game.players[1]

    -- search for element
    local element = assert(faketorio.find_element_by_id(id, player))

    local event = {}
    event.element = element
    event.player_index = 1
    event.button = defines.mouse_button_type.left
    event.alt = false
    event.control = false
    event.shift = false

    script.raise_event(defines.events.on_gui_click, event)
end

function faketorio.find_element_by_id(id, player)

    faketorio.print("Starting find by id for id [%s] and player [%s].", {id, player.name})
    local guis = {["top"] = player.gui.top,
                  ["left"] = player.gui.left,
                  ["center"] = player.gui.center,
                  ["goal"] = player.gui.goal}

    for name, gui in pairs(guis) do
        faketorio.print("Searching in gui [%s].", {name})
        for _, child in pairs(gui.children) do
            faketorio.print("Searching in gui element [%s/%s].", {name, child.name})
            local element = faketorio.do_find_element_by_id(id, child)
            if (element ~= nil) then
                return element
            end
        end
    end

    error(string.format("Could not find element with id [%s] for player [%s].", id, player.name))
end

function faketorio.do_find_element_by_id(id, element)

    if (element.name == id) then
        faketorio.print("Found element with id [%s].", {id})
        return element
    end

    -- explicitly check for this problem as I do not trust the factorio internals here
    if (element.children == nil) then
        faketorio.print("Element has no children.")
        return nil
    end

    for _, child in ipairs(element.children) do
        faketorio.print("Searching in gui element [%s/%s].", { element.name, child.name})
        local result = faketorio.do_find_element_by_id(id, child)
        if (result ~= nil) then
            return result
        end
    end
end


function feature(name, func)
    faketorio.print("Registering feature [%s].", {name})
    faketorio.features[name] = {}
    faketorio.current_name = name
    func()
end

function scenario(name, func)
    faketorio.print("Registering scenario [%s] for feature [%s]", {name, faketorio.current_name})
    faketorio.features[faketorio.current_name][name] = func
end

function faketorio.print(message, args)
    if (args) then
        message = string.format(message, unpack(args))
    end

    if (game) then
        for _, p in pairs(game.players) do
            p.print(message)
            game.write_file("faketorio.log", message .. "\n", true)
        end
    else
        print(message)
    end
end
if not faketorio then faketorio = {} end

faketorio.features = {}
faketorio.errors = {}
faketorio.listener = nil

function faketorio.run()

    if (faketorio.listener) then
        faketorio.listener.init()
    end

    local feature_count = faketorio.count(faketorio.features)
    local current_feature = 0
    for feature_name, feature in pairs(faketorio.features) do
        current_feature = current_feature + 1
        faketorio.log.info("Starting Feature [%s] (%s/%s).", { feature_name, current_feature, feature_count})

        if (faketorio.listener) then
            faketorio.listener.feature_started(feature_name)
        end

        local scenarios = feature.scenarios
        local scenario_count = faketorio.count(scenarios)
        local current_scenario = 0
        for scenario_name, scenario in pairs(scenarios) do

            current_scenario = current_scenario + 1
            faketorio.log.info("Starting Scenario %s (%s/%s).", {scenario_name, current_scenario, scenario_count})

            if (faketorio.listener) then
                faketorio.listener.scenario_started(current_scenario, scenario_count)
            end

            if (feature.before_scenario) then
                feature.before_scenario()
            end
            local status, error = pcall(scenario)
            if (feature.after_scenario) then
                feature.after_scenario()
            end

            if (status) then
                faketorio.log.debug("Finished Scenario %s.", {scenario_name})

                if (faketorio.listener) then
                    faketorio.listener.scenario_finished_success(current_scenario, scenario_count)
                end
            else
                faketorio.log.debug("Finished Scenario %s with failure %s.", {scenario_name, error})
                faketorio.error(feature_name, scenario_name, error)

                if (faketorio.listener) then
                    faketorio.listener.scenario_finished_failure(current_scenario, scenario_count)
                end
            end
        end

        if (faketorio.listener) then
            faketorio.listener.feature_finished(current_feature, feature_count)
        end

        faketorio.log.debug("Finished Feature %s.", {feature_name})
    end

    if (faketorio.listener) then
        faketorio.listener.testrun_finished()
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

    local result = faketorio.assemble_result_string(feature_count)
    faketorio.log.info(result)
end

function faketorio.assemble_result_string(feature_count)
    local result
    local error_count = faketorio.count(faketorio.errors)
    if (error_count > 0) then
        result = "TESTRUN FINISHED: FAILURE\n\n"
    else
        result = "TESTRUN FINISHED: SUCCESS\n\n"
    end

    result = result .. string.format("Run contained %s features.\n", feature_count)

    if (error_count > 0) then
        result = result .. "The following errors occured:\n"
    end
    for feature, scenarios in pairs(faketorio.errors) do
        for scenario, error in pairs(scenarios) do
            result = result .. string.format("Scenario %s - %s failed with error: %s\n\n", feature, scenario, error)
        end
    end

    return result
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

function faketorio.enter_text(id, text)
    local player = game.players[1]

    local element = assert(faketorio.find_element_by_id(id, player))

    local error_message = string.format("Element with id [%s] has invalid type [%s].", id, element.type)
    assert(element.type == "textfield" or element.type == "text-box", error_message)

    element.text = text
end

function faketorio.find_element_by_id(id, player)

    faketorio.log.trace("Starting find by id for id [%s] and player [%s].", {id, player.name})
    local guis = {["top"] = player.gui.top,
                  ["left"] = player.gui.left,
                  ["center"] = player.gui.center,
                  ["goal"] = player.gui.goal}

    for name, gui in pairs(guis) do
        faketorio.log.trace("Searching in gui [%s].", {name})
        for _, child in pairs(gui.children) do
            faketorio.log.trace("Searching in gui element [%s/%s].", {name, child.name})
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
        faketorio.log.trace("Found element with id [%s].", {id})
        return element
    end

    -- explicitly check for this problem as I do not trust the factorio internals here
    if (element.children == nil) then
        faketorio.log.trace("Element has no children.")
        return nil
    end

    for _, child in ipairs(element.children) do
        faketorio.log.trace("Searching in gui element [%s/%s].", { element.name, child.name})
        local result = faketorio.do_find_element_by_id(id, child)
        if (result ~= nil) then
            return result
        end
    end
end


function feature(name, func)
    faketorio.log.info("Registering feature [%s].", {name})
    faketorio.features[name] = {
        scenarios = {}
    }
    faketorio.current_name = name
    func()
end

function scenario(name, func)
    faketorio.log.info("Registering scenario [%s] for feature [%s]", {name, faketorio.current_name})
    faketorio.features[faketorio.current_name].scenarios[name] = func
end

function before_scenario(func)
    faketorio.log.info("Registering before_scenario for feature [%s]", {faketorio.current_name})
    faketorio.features[faketorio.current_name].before_scenario = func
end

function after_scenario(func)
    faketorio.log.info("Registering after_scenario for feature [%s]", {faketorio.current_name})
    faketorio.features[faketorio.current_name].after_scenario = func
end
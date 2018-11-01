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
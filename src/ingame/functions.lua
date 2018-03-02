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
        end
    else
        print(message)
    end
end
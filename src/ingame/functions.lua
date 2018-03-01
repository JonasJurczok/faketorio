if not faketorio then faketorio = {} end

faketorio.features = {}

function faketorio.run()
    for feature_name, scenarios in pairs(faketorio.features) do
        faketorio.print("Starting Feature %s.", { feature_name })

        for scenario_name, scenario in pairs(scenarios) do
            faketorio.print("Starting Scenario %s.", {scenario_name})
            scenario()
            faketorio.print("Finished Scenario %s.", {scenario_name})
        end

        faketorio.print("Finished Feature %s.", {feature_name})
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
        end
    else
        print(message)
    end
end
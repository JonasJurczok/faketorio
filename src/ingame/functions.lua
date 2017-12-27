if not faketorio then faketorio = {} end

faketorio.features = {}

function faketorio.run()
    for _, p in pairs(game.players) do
        p.print("Faketorio")
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
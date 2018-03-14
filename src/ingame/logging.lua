if not faketorio then faketorio = {} end

faketorio.log = {
    levels = {
        ["TRACE"] = 0,
        ["DEBUG"] = 1,
        ["INFO"] = 2,
        ["WARN"] = 3
    },
    level = "INFO"
}

function faketorio.log.trace(message, args)
    faketorio.log.log("TRACE", message, args)
end

function faketorio.log.debug(message, args)
    faketorio.log.log("DEBUG", message, args)
end

function faketorio.log.info(message, args)
    faketorio.log.log("INFO", message, args)
end

function faketorio.log.warn(message, args)
    faketorio.log.log("WARN", message, args)
end

function faketorio.log.log(level, message, args)

    local current_level = faketorio.log.levels[faketorio.log.level]

    if (faketorio.log.levels[level] < current_level) then
        return
    end

    if (args) then
        message = string.format(message, unpack(args))
    end

    message = string.format("%s: %s", level, message)

    faketorio.log.print(message)
end

function faketorio.log.print(message)

    if (game) then
        for _, p in pairs(game.players) do
            p.print(message)
            game.write_file("faketorio.log", message .. "\n", true)
        end
    else
        print(message)
    end
end

function faketorio.log.setTrace()
    faketorio.log.level = "TRACE"
end

function faketorio.log.setDebug()
    faketorio.log.level = "DEBUG"
end

function faketorio.log.setInfo()
    faketorio.log.level = "INFO"
end

function faketorio.log.setWarn()
    faketorio.log.level = "WARN"
end
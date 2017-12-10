if not faketorio then faketorio = {} end

require("os")
faketorio.lfs = require("lfs")
require("faketorio-helper")
require("faketorio-clean")
require("faketorio-assemble")

function faketorio.assemble()
end

function faketorio.execute()
    local args = faketorio.parse_arguments()

    if (args.verbose) then
        faketorio.verbose = true
    else
        faketorio.verbose = false
    end

    faketorio.log("Faketorio was started with the following parameters:")
    faketorio.log(args)

    faketorio.clean()
    if (args.clean) then
        return
    end
    -- always assemble the mod
    faketorio.assemble()

    if (args.test) then
        -- run tests
    elseif (args.run) then
        -- run
    elseif (args.build) then
        -- execute build
    end
end

function faketorio.log(message)
    if (not faketorio.verbose) then
        return
    end

    if (type(message) == "string" or message == nil) then
        print (message)
    else
        require"pl.pretty".dump(message)
    end
end
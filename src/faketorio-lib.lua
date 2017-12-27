if not faketorio then faketorio = {} end

require("os")
faketorio.lfs = require("lfs")
require("faketorio-helper")
require("faketorio-clean")
require("faketorio-assemble")

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

    -- allways assemble and load the config
    faketorio.load_config()
    faketorio.assemble()

    if (args.test) then
        -- run tests
        -- TODO: implement test mode
        faketorio.log("Running test mode")
    elseif (args.run) then
        faketorio.log("Running mod")
        faketorio.copy_directory(faketorio.output_folder, faketorio.factorio_mod_path .. "/" .. faketorio.output_name)

        -- TODO: add option to provide an existing savegame?
        local map = string.format("%s/maps/%s", args.path, os.date("%Y-%m-%d--%H-%M-%S", os.time()))
        local command = string.format("%s %s %s", faketorio.factorio_run_path, "%s", map)

        faketorio.log("Prepared command [" .. command .. "].")

        os.execute(string.format(command, "--create"))
        os.execute(string.format(command, "--load-game"))
    elseif (args.build) then
        -- execute build
        -- TODO: implement assembling the mod (2)
        faketorio.log("Packaging mod")
    end
end
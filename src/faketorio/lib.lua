if not faketorio then faketorio = {} end

require("os")
faketorio.lfs = require("lfs")
require("faketorio.helper")
require("faketorio.clean")
require("faketorio.build")
require("faketorio.test")

function faketorio.execute(args)
    if (args.verbose) then
        faketorio.verbose = true
    else
        faketorio.verbose = false
    end

    faketorio.log("Faketorio was started with the following parameters:")
    faketorio.log(args)

    faketorio.clean()
    if (args.clean) then
        -- explicitly break to make it more clear that nothing else will happen.
        return
    end

    -- allways assemble and load the config
    faketorio.load_config()
    faketorio.build()

    if (args.build) then
        -- same as for clean
        return
    end

    if (args.test) then
        -- run tests
        faketorio.log("Running test mode")

        faketorio.copy_test_infrastructure()
        faketorio.copy_tests()
        faketorio.integrate_tests()

        faketorio.run(args.path)
    elseif (args.run) then
        faketorio.run(args.path)
    elseif (args.copy) then
        faketorio.log("Copying mod to Factorio mod folder...")
        faketorio.copy_directory(faketorio.output_folder, faketorio.factorio_mod_path .. "/" .. faketorio.output_name)
        faketorio.log("Copying finished.")
    elseif (args.package) then
        -- execute build
        -- TODO: implement packaging the mod (2)
        faketorio.log("Packaging mod")
    end
end

function faketorio.run(path)
    faketorio.log("Running mod")
    faketorio.copy_directory(faketorio.output_folder, faketorio.factorio_mod_path .. "/" .. faketorio.output_name)

    local map = string.format("%s/maps/%s", path, os.date("%Y-%m-%d--%H-%M-%S", os.time()))
    local command = string.format("%s %s %s", faketorio.factorio_run_path, "%s", map)

    faketorio.log("Prepared command [" .. command .. "].")

    os.execute(string.format(command, "--create"))
    os.execute(string.format(command, "--load-game"))
end
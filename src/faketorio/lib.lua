if not faketorio then faketorio = {} end

require("os")
faketorio.lfs = require("lfs")
require("faketorio.helper")
require("faketorio.clean")
require("faketorio.build")
require("faketorio.test")
require("faketorio.package")

function faketorio.execute(args)
    if (args.verbose) then
        faketorio.verbose = true
    else
        faketorio.verbose = false
    end

    faketorio.print_message("Faketorio was started with the following parameters:")
    faketorio.print_message(args)

    faketorio.clean()
    if (args.clean) then
        -- explicitly break to make it more clear that nothing else will happen.
        return
    end

    -- allways assemble and load the config
    faketorio.load_config(args.config)
    faketorio.build()

    if (args.build) then
        -- same as for clean
        return
    end

    if (args.test) then
        -- run tests
        faketorio.print_message("Running test mode")

        faketorio.prepare_tests()

        faketorio.create_map_and_run_factorio(args.path)
    elseif (args.run) then
        faketorio.create_map_and_run_factorio(args.path)
    elseif (args.copy) then

        faketorio.prepare_tests()

        faketorio.print_message("Copying mod to Factorio mod folder...")
        faketorio.copy_mod_to_factorio_mod_dir()

        faketorio.print_message("Copying finished.")
    elseif (args.package) then
        -- execute build
        faketorio.print_message("Packaging mod")
        faketorio.package()
    end
end

function faketorio.copy_mod_to_factorio_mod_dir()
    assert(faketorio.output_folder, "No output folder found.")
    assert(faketorio.factorio_mod_path, "Factorio mod directory not configured.")
    assert(faketorio.output_name, "Mod name not recognized correctly.")
    faketorio.copy_directory(faketorio.output_folder, faketorio.factorio_mod_path .. "/" .. faketorio.output_name)
end

function faketorio.create_map_and_run_factorio(path)
    faketorio.print_message("Running mod")
    faketorio.copy_mod_to_factorio_mod_dir()

    local map = string.format("%s/maps/%s", path, os.date("%Y-%m-%d--%H-%M-%S", os.time()))
    local command = string.format("%s %s %s", faketorio.factorio_run_path, "%s", map)

    faketorio.print_message("Prepared command [" .. command .. "].")

    os.execute(string.format(command, "--create"))
    os.execute(string.format(command, "--load-game"))
end
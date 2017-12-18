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
    -- always assemble the mod
    faketorio.assemble()

    if (args.test) then
        -- run tests
        -- TODO: implement test mode
        faketorio.log("Running test mode")
    elseif (args.run) then
        faketorio.log("Running mod")
        faketorio.load_config()
        faketorio.copy_directory(faketorio.output_folder, faketorio.factorio_mod_path)
    elseif (args.build) then
        -- execute build
        -- TODO: implement assembling the mod (2)
        faketorio.log("Packaging mod")
    end
end
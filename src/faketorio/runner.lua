require("faketorio.lib")

function faketorio.parse_arguments()
    local argparse = require("argparse")
    local parser = argparse("Faketorio", "Automated testing for your Factorio mod.")
    parser:command("build",
            "Create a folder named after the mod under \"target\" and copy all source files there. " ..
                    "No further actions are initialized",
            "This command can be used if you just want to check the assembled mod without actually " ..
                    "doing anything with it. \n" ..
                    "It is also the basis for all other steps and will be called implicitly.")
    parser:command("clean",
            "Clean the working directory \"target\". This will be implicitly done by the other commands")
    parser:command("copy",
            "Copy the mod to the factorio mod directory without running factorio or integrating tests.",
            "This is intended for when you already have factorio running and just want to quickly " ..
                    "iterate without changing translations etc.")
    parser:command("package",
            "Build the mod for uploading to the Factorio mod portal.",
            "This command creates a zip file according to the Factorio standard " ..
                    "end and places it in the current directory.")
    parser:command("run",
            "Run the game with the current version of the mod.",
            "This command will assemble the mod, copy all data to the factorio mod dir and then start Factorio.")
    parser:command("test",
            "Run all your tests in Factorio.",
            "Run the game with the current version of the mod and execute all tests as soon as you are in game.")
    parser:flag("-v --verbose",
            "Show log output in the terminal.")
    parser:option("-c --config", "Path to the config file to use. Defaults to current folder.")

    local args = parser:parse()
    args.path = faketorio.lfs.currentdir()
    return args
end

faketorio.execute(faketorio.parse_arguments())
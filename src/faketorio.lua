-- local factorio_dir = "D:\Spiele\steamapps\common\Factorio\bin\x64"
-- local factorio_exe = factorio_dir .. "\factorio.exe"
-- local factorio_mod_dir = "C:\Users\jonas\AppData\Roaming\Factorio\mods"

-- depends on:
-- argparse : https://github.com/mpeterv/argparse
-- luafilesystem : http://keplerproject.github.io/luafilesystem/manual.html

require("faketorio-lib")

function faketorio.parse_arguments()
    local argparse = require("argparse")
    local parser = argparse("Faketorio", "Automated testing for your Factorio mod.")
    parser:command("clean",
        "Clean the working directory \"target\". This will be implicitly done by the other commands")
    parser:command("build",
        "Build the mod for uploading to the Factorio mod portal.",
        "This command creates a zip file according to the Factorio standard and places it in the current directory.")
    parser:command("run",
        "Run the game with the current version of the mod.",
        "This command will assemble the mod, copy all data to the factorio mod dir and then start Factorio.")
    parser:command("test",
        "Run all your tests in Factorio.",
        "Run the game with the current version of the mod and execute all tests as soon as you are in game.")

    parser:flag("-v --verbose",
        "Show log output in the terminal.")

    local args = parser:parse()
    args.path = faketorio.lfs.currentdir()
    return args
end

faketorio.execute()
if not faketorio then faketorio = {} end

require("faketorio-helper")

function faketorio.assemble()
    -- TODO: add more defaults (settings dat files)
    -- TODO: let user add more directories/files

    local info = faketorio.get_mod_info()
    local folder = "target/"..info.name.."_"..info.version

    faketorio.log("Assembling mod in folder ["..folder.."].")

    assert(faketorio.lfs.mkdir("target"))
    assert(faketorio.lfs.mkdir(folder))

    faketorio.copy_directory("src", folder)
    faketorio.copy_directory("locale", folder.."/locale")
    faketorio.copy_file("info.json", folder.."/info.json")
    faketorio.copy_file("control.lua", folder.."/control.lua")
end

if not faketorio then faketorio = {} end

require("faketorio.helper")

function faketorio.build()
    -- TODO: add more defaults (settings dat files)
    -- TODO: let user add more directories/files

    local info = faketorio.get_mod_info()
    faketorio.output_name = info.name.."_"..info.version
    local folder = "target/" .. faketorio.output_name

    faketorio.print_message("Assembling mod in folder ["..folder.."].")

    assert(faketorio.lfs.mkdir("target"))
    assert(faketorio.lfs.mkdir(folder))

    faketorio.copy_directory("src", folder)
    if (faketorio.lfs.attributes("locale")) then
        faketorio.copy_directory("locale", folder.."/locale")
    end
    faketorio.copy_file("info.json", folder.."/info.json")
    faketorio.copy_file_if_exists("thumbnail.png", folder.."/thumbnail.png")
    faketorio.copy_file_if_exists("changelog.txt", folder.."/changelog.txt")

    if (faketorio.include_files) then
        for src, dest in pairs(faketorio.include_files) do
            faketorio.copy_file(src, folder .. "/" .. dest)
        end
    end

    -- TODO: find better name
    faketorio.output_folder = folder
end

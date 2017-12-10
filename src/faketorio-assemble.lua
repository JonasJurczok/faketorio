if not faketorio then faketorio = {} end

function faketorio.assemble()
    -- TODO: add more defaults (settings dat files)
    -- TODO: let user add more directories/files
    faketorio.copy_directory("src", "target")
    faketorio.copy_directory("locale", "target/locale")
    faketorio.copy_file("info.json", "target/info.json")
end

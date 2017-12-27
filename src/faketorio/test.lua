function faketorio.copy_test_infrastructure()
    -- config has been loaded
    local src = faketorio.faketorio_path.."/ingame"
    local dest = faketorio.output_folder.."/faketorio"
    faketorio.copy_directory(src, dest)
end
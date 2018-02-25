if not faketorio then faketorio = {} end

function faketorio.clean()
    local attr = faketorio.lfs.attributes("target")
    if (attr == nil) then
        return
    end

    faketorio.delete_directory("target")
    faketorio.lfs.rmdir("target")
end

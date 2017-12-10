if not faketorio then faketorio = {} end

function faketorio.clean()
    faketorio.delete_dir("target")
    faketorio.lfs.rmdir("target")
end

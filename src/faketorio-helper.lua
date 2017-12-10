if not faketorio then faketorio = {} end

function faketorio.delete_dir(directory)
    -- recursive delete folder and files
    for file in faketorio.lfs.dir(directory) do
        if (file ~= "." and file ~= "..") then
            local path = directory .."/".. file
            local mode = faketorio.lfs.attributes(path, "mode")
            if mode == "file" then
                faketorio.log("Removing file ["..path.."].")
                os.remove(path)
            elseif mode == "directory" then
                faketorio.delete_dir(path)
            end
        end
    end
    faketorio.log("Removing directory ["..directory.."].")
    faketorio.lfs.rmdir(directory)
end


if not faketorio then faketorio = {} end

function faketorio.delete_dir(directory)
    if (faketorio.lfs.attributes(directory) == nil) then
        return
    end

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

function faketorio.copy_directory(src, dest, pattern)
    faketorio.log("Copying directory ["..src.."].")
    faketorio.lfs.mkdir(dest)

    for file in faketorio.lfs.dir(src) do
        if (file ~= "." and file ~= "..") then
            local src_path = src .."/".. file
            local dest_path = dest .."/".. file
            local mode = faketorio.lfs.attributes(src_path, "mode")

            if mode == "file" then

                if (pattern == nil or string.find(file, pattern)) then
                    faketorio.log("Copying file [".. src_path .."].")
                    faketorio.copy_file(src_path, dest_path)
                end
            elseif mode == "directory" then
                faketorio.copy_directory(src_path, dest_path)
            end
        end
    end
end

function faketorio.copy_file(path_src, path_dst)
    local source = assert(io.open(path_src, "rb"))
    local content = source:read("*all")
    source:close()

    local target = assert(io.open(path_dst, "wb"))
    target:write(content)
    target:close()
end

function faketorio.read_file(path)
    local f = assert(io.open(path, "r"))
    local content = f:read("*all")
    f:close()

    return content
end

function faketorio.get_mod_info()
    local json = require("JSON")
    return json:decode(faketorio.read_file("info.json"))
end

function faketorio.load_config()
    faketorio.log("Loading .faketorio config.")
    -- TODO: add parameter to change config location
    local content = faketorio.read_file(os.getenv("HOME") .. "/.faketorio")

    local tea = require("teateatea")
    local cfg = tea.kvpack(content, "=", "\n", true, true, true)

    for key, value in pairs(cfg) do
        faketorio.log(string.format("Setting [%s] to [%s]", key, value))
        faketorio[key] = value
    end
end

function faketorio.log(message)
    if (not faketorio.verbose) then
        return
    end

    if (type(message) == "string" or message == nil) then
        print (message)
    else
        require"pl.pretty".dump(message)
    end
end
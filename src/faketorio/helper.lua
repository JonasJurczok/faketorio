if not faketorio then faketorio = {} end

function faketorio.delete_directory(directory)
    if (faketorio.lfs.attributes(directory) == nil) then
        return
    end

    -- recursive delete folder and files
    for file in faketorio.lfs.dir(directory) do
        if (file ~= "." and file ~= "..") then
            local path = directory .."/".. file
            local mode = faketorio.lfs.attributes(path, "mode")
            if mode == "file" then
                faketorio.print_message("Removing file ["..path.."].")
                os.remove(path)
            elseif mode == "directory" then
                faketorio.delete_directory(path)
            end
        end
    end
    faketorio.print_message("Removing directory ["..directory.."].")
    faketorio.lfs.rmdir(directory)
end

function faketorio.copy_directory(src, dest, pattern)
    faketorio.print_message("Copying directory ["..src.."].")
    faketorio.lfs.mkdir(dest)

    for file in faketorio.lfs.dir(src) do
        if (file ~= "." and file ~= "..") then
            local src_path = src .."/".. file
            local dest_path = dest .."/".. file
            local mode = faketorio.lfs.attributes(src_path, "mode")

            if mode == "file" then

                if (pattern == nil or string.find(file, pattern)) then
                    faketorio.print_message("Copying file [".. src_path .."].")
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

function faketorio.copy_file_if_exists(path_src, path_dst)
    if (faketorio.lfs.attributes(path_src) == nil) then
        return false
    end

    faketorio.copy_file(path_src, path_dst)
    return true
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

function faketorio.load_config(path)

    if (path == nil or path == "") then
            path = ".faketorio"
    end

    faketorio.print_message("Loading config from [%s].", path)

    local content = faketorio.read_file(path)

    content = string.gsub(content, "\\", "\\\\")

    faketorio.print_message(content)

    local config = {}
    local chunk, err = load(content, "config", "t", config)
    if (err) then
        error("Loading config failed: " .. err)
    end
    -- actually execute the config file as lua code
    chunk()

    if (config == nil) then
        error("Loading config failed.")
    end

    for key, value in pairs(config) do
        faketorio.print_message(string.format("Setting [%s] to [%s]", key, value))
        faketorio[key] = value
    end
end

function faketorio.print_message(message, ...)
    if (not faketorio.verbose) then
        return
    end

    if (message == nil) then
        print ("Message was nil.")
    end

    if (type(message) == "string") then
        print (string.format(message, (...)))
    else
        require"pl.pretty".dump(message)
    end
end
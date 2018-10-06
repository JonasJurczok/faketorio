if not faketorio then faketorio = {} end

require("faketorio.helper")

function faketorio.package()

    local cfg = require("luarocks.core.cfg")

    assert(faketorio.lfs.chdir("target"))
    -- ULTRA HACK because installing zlib on windows is a huuuuge pain
    -- we ship our own 7z.exe and .dll and use luarocks to find our installation dir.
    if (cfg.arch:find("win32")) then
        local zip = faketorio.capture_command_output("luarocks show faketorio --rock-dir").."/tools/7z.exe"
        local command = zip .. " a " .. faketorio.output_name ..".zip " .. faketorio.output_name
        os.execute(command)
    else
        local zip = require("luarocks.tools.zip")
        zip.zip(faketorio.output_name .. ".zip", faketorio.output_name)
    end
    assert(faketorio.lfs.chdir(".."))

end

-- courtesy of https://stackoverflow.com/questions/132397/get-back-the-output-of-os-execute-in-lua
function faketorio.capture_command_output(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

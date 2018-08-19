if not faketorio then faketorio = {} end

require("faketorio.helper")

function faketorio.package()
    local zip = require("luarocks.tools.zip")

    assert(faketorio.lfs.chdir("target"))
    zip.zip(faketorio.output_name .. ".zip", faketorio.output_name)
    assert(faketorio.lfs.chdir(".."))
end

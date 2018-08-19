if not faketorio then faketorio = {} end

require("faketorio.helper")

function faketorio.package()
    -- apparently sometimes this is not done properly.
    require("luarocks.core.cfg"):init()
    require("luarocks.fs"):init()

    local zip = require("luarocks.tools.zip")

    assert(faketorio.lfs.chdir("target"))
    zip.zip(faketorio.output_name .. ".zip", faketorio.output_name)
    assert(faketorio.lfs.chdir(".."))
end

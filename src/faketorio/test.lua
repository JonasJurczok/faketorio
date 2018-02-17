require("faketorio.helper")

function faketorio.copy_test_infrastructure()
    -- config has been loaded
    local src = faketorio.faketorio_path.."/ingame"
    local dest = faketorio.output_folder.."/faketorio"
    faketorio.copy_directory(src, dest)
end

function faketorio.copy_tests()
    faketorio.copy_directory("spec", faketorio.output_folder.."/faketorio/features", "feature")
end

function faketorio.integrate_tests()
    faketorio.log("Integrating tests with the mod.")
    local control = io.open(faketorio.output_folder .. "/control.lua", "a")

    control:write("\nrequire(\"faketorio.core\")\n")

    for file in faketorio.lfs.dir(faketorio.output_folder .. "/faketorio/features") do
        if (string.find(file, "_feature.lua")) then
            file = string.sub(file, 1, -5)
            faketorio.log("Integrating test file [" .. file .. "].")
            control:write("\nrequire(\"faketorio.features." .. file .. "\")\n")
        end
    end

    control:close()
    faketorio.log("Integrating tests finished.")

end
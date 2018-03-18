require("faketorio.functions")
require("faketorio.logging")
require("faketorio.mocks")
require("faketorio.ui")

commands.add_command("faketorio", "Run faketorio tests", function(_)
    faketorio.run()
end)
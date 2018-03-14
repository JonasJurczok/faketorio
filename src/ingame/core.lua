require("faketorio.functions")
require("faketorio.logging")

commands.add_command("faketorio", "Run faketorio tests", function(_)
    faketorio.run()
end)
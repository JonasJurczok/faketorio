require("faketorio.functions")

commands.add_command("faketorio", "Run faketorio tests", function(_)
    faketorio.run()
end)
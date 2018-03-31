
globals = {"faketorio", "busted", "feature", "scenario", "before_scenario", "after_scenario", "commands", "game", "defines", "script", "when", "unpack"}
read_globals = {
    os = {
        fields = {
            execute = {
                fields = {
                    revert = {}
                }
            }
        }
    }
}
files['spec/*_spec.lua'].std = 'max+busted'
files['spec/*_IGNORED_.lua'].std = 'max+busted'

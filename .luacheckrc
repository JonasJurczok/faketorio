
globals = {"faketorio", "busted", "feature", "scenario", "commands", "game", "defines", "script", "when"}
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

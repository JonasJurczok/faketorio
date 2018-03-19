
faketorio.listener = {}

function faketorio.listener.init()

    faketorio.log.trace("Started initializing Faketorio UI.")

    for _, p in pairs(game.players) do

        faketorio.log.debug("Initializing UI for player [%s].", {p.name})

        local res = p.display_resolution

        local main = p.gui.center.add({
            type = "frame",
            name = "faketorio_progress_frame",
            caption = "Test progress",
            direction = "vertical"
        })

        main.style.width = res.width * 0.4

        main.add({
            type = "label",
            name = "faketorio_feature_label",
            caption = "Preparing to run features..."
        })

        local feature_progress = main.add({
            type = "progressbar",
            name = "faketorio_feature_progress"
        })
        feature_progress.style.color = {r = 0, g = 1, b = 0, a = 1}
        feature_progress.style.horizontally_stretchable = true

        main.add({
            type = "label",
            name = "faketorio_scenario_label",
            caption = "Preparing to run scenarios..."
        })

        local scenario_progress = main.add({
            type = "progressbar",
            name = "faketorio_scenario_progress"
        })
        scenario_progress.style.color = { r = 0, g = 1, b = 0, a = 1}
        scenario_progress.style.horizontally_stretchable = true
    end
end

function faketorio.listener.feature_started(name)
    for _, p in pairs(game.players) do
        faketorio.listener.feature_label(p).caption = string.format("Running feature: \"%s\"", name)
    end
end

function faketorio.listener.feature_finished(current, max)
    faketorio.listener.feature_count = max
    for _, p in pairs(game.players) do
        faketorio.listener.feature_bar(p).value = max / current
    end
end

function faketorio.listener.scenario_started(name)
    for _, p in pairs(game.players) do
        faketorio.listener.scenario_label(p).caption = string.format("Running scenario: \"%s\"", name)
    end
end

function faketorio.listener.scenario_finished_success(current, max)
    for _, p in pairs(game.players) do
        faketorio.listener.scenario_bar(p).value = max / current
    end
end

function faketorio.listener.scenario_finished_failure(current, max)
    for _, p in pairs(game.players) do
        faketorio.listener.scenario_bar(p).value = max / current
        faketorio.listener.scenario_bar(p).style.color = { r = 1, g = 0, b = 0, a = 1}
        faketorio.listener.feature_bar(p).style.color = { r = 1, g = 0, b = 0, a = 1}
    end
end

function faketorio.listener.testrun_finished()

    local result = faketorio.assemble_result_string(faketorio.listener.feature_count)

    for _, p in pairs(game.players) do
        local scroll = p.gui.center.faketorio_progress_frame.add({
            type = "scroll-pane",
            name = "faketorio_scroll"
        })

        scroll.vertical_scroll_policy = "auto"
        scroll.horizontal_scroll_policy = "auto"
        scroll.style.maximal_height = p.display_resolution.height * 0.25
        scroll.style.minimal_height = scroll.style.maximal_height

        local textbox = scroll.add({
            type = "text-box",
            name = "faketorio_run_result"
        })

        textbox.text = result
        textbox.style.horizontally_stretchable = true
        textbox.style.vertically_stretchable = true
    end
end

function faketorio.listener.feature_bar(player)
    return player.gui.center.faketorio_progress_frame.faketorio_feature_progress
end

function faketorio.listener.feature_label(player)
    return player.gui.center.faketorio_progress_frame.faketorio_feature_label
end

function faketorio.listener.scenario_bar(player)
    return player.gui.center.faketorio_progress_frame.faketorio_scenario_progress
end

function faketorio.listener.scenario_label(player)
    return player.gui.center.faketorio_progress_frame.faketorio_scenario_label
end
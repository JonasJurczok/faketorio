
if not faketorio then faketorio = {world = {}} end

function faketorio.initialize_world()

  faketorio.world.game = {}
  faketorio.world.script = {}
  faketorio.world.global = {}
  faketorio.world.serpent = require("serpent")

  faketorio.world.game.players = {}
  faketorio.world.game.players[1] = faketorio.create_player("Player_1")
  faketorio.world.game.players[2] = faketorio.create_player("Player_2")

  faketorio.world.settings = faketorio.create_settings(faketorio.world.game.players)

  return faketorio.world
end

function faketorio.create_player(name)
  local player = {}
  player.name = name

  player.gui = {}

  player.gui.center = faketorio.create_base_gui("center")
  player.gui.left = faketorio.create_base_gui("left")
  player.gui.right = faketorio.create_base_gui("right")

  return player
end

function faketorio.create_base_gui(name)
  local gui = {}
  gui.add = faketorio.create_add_function(gui)
  gui.children = {}
  gui.name = name
  return gui
end

function faketorio.create_add_function(element)
  return function(child)
    if not child then
      error('Trying to add nil child to element '..element.name..'.')
    elseif not child.name then
      error('Trying to add child to element '..element.name..' that has no name.')
    end

    element[child.name] = child
    table.insert(element.children, child)

    child.add = faketorio.create_add_function(child)
    child.destroy = faketorio.create_destroy_function(child)
    child.style = {}
    child.parent = element
    child.children = {}
    return child
  end
end

function faketorio.create_destroy_function(element)
  return function()
    local parent = element.parent

    for i, child in ipairs(parent.children) do
      if (child.name == element.name) then
        table.remove(parent.children, i)
        break
      end
    end

    parent[element.name] = nil
    element.parent = nil
  end
end

function faketorio.create_settings(players)
  local settings = {}

  for _, player in pairs(players) do
    settings[player.name] = {}
  end

  settings.get_player_settings = function(player)
    return settings[player.name]
  end

  return settings
end

function faketorio.add_default_setting(key, value)

  for _, player in pairs(faketorio.world.game.players) do
    faketorio.world.settings[player.name][key] = {["key"] = key, ["value"] = value}
  end
end

return faketorio

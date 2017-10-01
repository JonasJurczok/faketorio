

require("faketorio")

function faketorio.initialize_world_busted()
  local world = faketorio.initialize_world()

  for name, element in pairs(world) do
    _G[name] = element
  end
end

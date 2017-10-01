

describe("Faketorio should be usable with busted", function()
  setup(function()
    require("src/faketorio_busted")
  end)

  before_each(function()

  end)

  it("should initialize busted globals correctly", function()

    faketorio.initialize_world_busted()

    assert.is_not_nil(_G.game)
    assert.is_equal(#_G.game.players, 2)
  end)

  it("should overwrite changed values upon initializsation", function()
    faketorio.initialize_world_busted()
    _G.game.blub = "wololo"

    faketorio.initialize_world_busted()

    assert.is_nil(_G.game.blub)
  end)
end)



describe('Basic faketorio features', function()
  require('src/faketorio')

  before_each(function()
    _G.faketorio.initialize_world()
  end)

  it('creates the world correctly', function()
    local world = faketorio.initialize_world()

    assert.is_truthy(world.game)
    assert.is_truthy(world.script)
    assert.is_truthy(world.global)
    assert.is_truthy(world.serpent)
    assert.is_truthy(world.game.players)

    assert.are.equal(#world.game.players, 2)
  end)

  it('shuld overwrite existing values on initialization', function()
    _G.faketorio.world.game.blub = "asd"

    _G.faketorio.initialize_world()

    assert.is_falsy(_G.faketorio.world.game.blub)
  end)

  it('should add guis to players', function()
    for _, player in pairs(_G.faketorio.world.game.players) do
      assert.is_truthy(player.gui.left)
      assert.is_truthy(player.gui.right)
      assert.is_truthy(player.gui.center)

      assert.is_truthy(player.gui.left.add)
      assert.is_truthy(player.gui.right.add)
      assert.is_truthy(player.gui.center.add)
    end
  end)

  it('should create guis that allow subsequent adding of children', function()
    local gui = faketorio.create_base_gui("base")
    local a = gui.add({name = "a"})
    local b = a.add({name = "b"})
    local c = b.add({name = "c"})

    assert.is_truthy(c.add)
  end)

  it('should fail adding a child if the name is not set or the child is nil', function()
    local gui = faketorio.create_base_gui("base")
    assert.has_error(function() gui.add() end)
    assert.has_error(function() gui.add(nil) end)
    assert.has_error(function() gui.add({}) end)
  end)
end)

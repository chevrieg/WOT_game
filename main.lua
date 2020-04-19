local screen = require "screen"
local story = require "story"
local game = require "game"
local debrief = require "debrief"


current_level = 1
-- Screen 0 title
-- Screen 1 story
-- Screen 2 game init
-- Screen 3 game
-- Screen 4 debrief init
-- Screen 5 debrief init

current_screen = 0

function love.load()
  love.window.setTitle("Rock Band Whispers on tree")
  screen_load()
  story_load()
  game_load()
  debrief_load()
end

function love.update(dt)
  if current_screen == 0 then
    screen_update(dt)
  elseif current_screen == 1 then
    story_init_dialog()
    story_update(dt)
    current_screen = 6
  elseif current_screen == 2 then
    game_init()
    game_update(dt)
    current_screen = 3
  elseif current_screen == 3 then
    game_update(dt)
  elseif current_screen == 4 then
    a, b = game_getscore()
    debrief_init(a, b)
    current_screen = 5
  elseif current_screen == 5 then
    debrief_update(dt)
  elseif current_screen == 6 then
    story_update(dt)
  end
end

function love.draw()
  if current_screen == 0 then
    screen_draw()
  -- elseif current_screen == 1 then

  elseif current_screen == 3 then
    game_draw()
  elseif current_screen == 5 then
    debrief_draw()
  elseif current_screen == 6 then
    story_draw()
  end
end

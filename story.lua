local utf8 = require "utf8"
local next = 0
local timer_next = 0.2
local story_index = 1

function story_load()
  image_background = love.graphics.newImage("assets/background.png")
  sp_background = love.graphics.newQuad(0, 0, 800, 600, image_background:getDimensions())

  dialog1 = love.audio.newSource("assets/dialog.mp3", "static")
  dialogbis = love.audio.newSource("assets/dialogbis.mp3", "static")
  dialog2 = love.audio.newSource("assets/dialog2.mp3", "static")
  dialog3 = love.audio.newSource("assets/dialog3.mp3", "static")
  dialog4 = love.audio.newSource("assets/dialog4.mp3", "static")
  dialog5 = love.audio.newSource("assets/dialog5.mp3", "static")
  dialog6 = love.audio.newSource("assets/dialog6.mp3", "static")
  screamer = love.audio.newSource("assets/screamer.mp3", "static")

  dje = love.graphics.newImage("assets/dje.png")
  guss = love.graphics.newImage("assets/guigui.png")
  leo = love.graphics.newImage("assets/leo.png")
  kev = love.graphics.newImage("assets/kev.png")
  antho = love.graphics.newImage("assets/antho.png")
  sha = love.graphics.newImage("assets/sha.png")
  ampli = love.graphics.newImage("assets/ampli.png")
  exo = love.graphics.newImage("assets/exo.png")

  sp_dje = love.graphics.newQuad(0, 0, 256, 256, dje:getDimensions())
  sp_guss = love.graphics.newQuad(0, 0, 256, 256, guss:getDimensions())
  sp_leo = love.graphics.newQuad(0, 0, 256, 256, leo:getDimensions())
  sp_kev = love.graphics.newQuad(0, 0, 256, 256, kev:getDimensions())
  sp_antho = love.graphics.newQuad(0, 0, 256, 256, antho:getDimensions())
  sp_sha = love.graphics.newQuad(0, 0, 256, 256, sha:getDimensions())
  sp_ampli = love.graphics.newQuad(0, 0, 256, 256, ampli:getDimensions())
  sp_exo = love.graphics.newQuad(0, 0, 256, 256, exo:getDimensions())

  screenWidth, screenHeight = love.window.getMode()

  dialogs ={dialog1,
            dialog2,
             dialog3,
              dialog4,
            dialog5,
          dialog6,
          dialogbis,
          screamer}

  persos = {{dje, sp_dje},
            {guss, sp_guss},
            {leo, sp_leo},
            {kev, sp_kev},
            {antho, sp_antho},
            {sha, sp_sha},
            {ampli, sp_ampli},
            {exo, sp_exo}
          }
end

function story_init_dialog()
  story = require(string.format("assets/story_%d", current_level))
  story_index = 1
  next_dialog()
end

function next_dialog()
  if story_index <= table.getn(story) then
    text = story[story_index][1]
    image = persos[story[story_index][2]]
    if dialogs[story[story_index][3]] ~= nil then
      play_index = story[story_index][3]
      if play_index == 1 then
        if string.len(text) < 25 then
          play_index = 7
        end
      end
      love.audio.play(dialogs[play_index])
    end
  else
    if current_level == 7 then
      current_level = 1
      current_screen = 0
    else
    current_screen = 2
    end
  end
end

function story_update(dt)
  if next == 1 then
    timer_next = timer_next - dt
  end

  touches = love.touch.getTouches()

  for i, id in ipairs(touches) do
      local x, y = love.touch.getPosition(id)
      if x > 0 and x < 800 then
        if y > 0 and y < 600 then
          if next == 0 then
            next = 1
        end
      end
    end
  end

  if love.keyboard.isDown("space") then
    if next == 0 then
      next = 1
    end
  end
  if next == 1 and not love.keyboard.isDown("space") and timer_next < 0 then
      next = 0
      timer_next = 0.2
      story_index = story_index + 1
      next_dialog()
      -- current_screen = 0
  end

end

function story_draw()
  love.graphics.draw(image_background, sp_background, 0, 0)
  if story[story_index][2] ~= 0 then
    love.graphics.draw(image[1], image[2], 265, 100)
  end
  love.graphics.printf(text, 0, 400, screenWidth, "center")

end

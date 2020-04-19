local next = 0
local timer_next = 0.2
local valid = 0
local total = 0
local pourcent = 0

function debrief_load()
  win = love.audio.newSource("assets/WOT_win.mp3", "static")
  fail = love.audio.newSource("assets/WOT_fail.mp3", "static")

  image_background = love.graphics.newImage("assets/background.png")
  sp_background = love.graphics.newQuad(0, 0, 800, 600, image_background:getDimensions())

  dialog1 = love.audio.newSource("assets/dialog.mp3", "static")

  guss = love.graphics.newImage("assets/guigui.png")

  sp_guss = love.graphics.newQuad(0, 0, 256, 256, guss:getDimensions())

  screenWidth, screenHeight = love.window.getMode()

end

function debrief_init(val1, val2)
  next = 0
  timer_next = 0.2
  valid = val1
  total = val2
  pourcent = valid * 100 / total
  objectif = 92
  if current_level == 6 then
    objectif = 80
  else
    objectif = 92
  end
  if pourcent < objectif then
    love.audio.play(fail)
  else
    love.audio.play(win)
  end
end

function debrief_update(dt)

  if next == 1 then
    timer_next = timer_next - dt
  end
  if love.keyboard.isDown("space") then
    if next == 0 then
      next = 1
    end
  end
  if next == 1 and not love.keyboard.isDown("space") and timer_next < 0 then
      if pourcent < objectif then
        current_screen = 2
        love.audio.stop()
      else
        current_level = current_level + 1
        current_screen = 1
        love.audio.stop()
      end
  end
end

function debrief_draw()
  love.graphics.draw(image_background, sp_background, 0, 0)
  love.graphics.draw(guss, sp_guss, 265, 100)
  love.graphics.printf(string.format("Ton score est de %d sur %d, sois %.1f pourcent", valid, total, pourcent), 0, 400, screenWidth, "center")

  if pourcent > objectif then
    love.graphics.printf("C'est bon ça !!!", 0, 425, screenWidth, "center")
  else
    love.graphics.printf("Il va falloir bosser encore...", 0, 425, screenWidth, "center")
  end
end

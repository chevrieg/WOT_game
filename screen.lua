local next = 0
local timer_next = 0.2
local x = 0
local y = 0

function screen_load()
  intro = love.audio.newSource("assets/WOT_intro.mp3", "static")
  love.graphics.setFont(love.graphics.newFont(18))
  image_title = love.graphics.newImage("assets/title.png")
  sp_title = love.graphics.newQuad(0, 0, 800, 600, image_title:getDimensions())
end

function screen_update(dt)
  love.audio.play(intro)
  if next == 1 then
    timer_next = timer_next - dt
  end

  if love.keyboard.isDown("space") then
    if next == 0 then
      next = 1
    end
  end
  if next == 1 and not love.keyboard.isDown("space") and timer_next < 0 then
      next =0
      timer_next = 0.2
      current_screen = 1
      love.audio.stop()
  end

end


function screen_draw()
  love.graphics.draw(image_title, sp_title, 0, 0)
  love.graphics.print("Appuyer sur <espace pour commencer>", 200, 400)
end

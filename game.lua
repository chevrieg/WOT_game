-- local math = require "math"
require "story"
local a_start = 320
local a_stop = 200
local z_start = 360
local z_stop = 300
local e_start = 400
local e_stop = 400
local r_start = 440
local r_stop = 500
local t_start = 480
local t_stop = 600
local y_start = 100
local y_stop = 550

local pourcent = 0

function game_load()

  image_background = love.graphics.newImage("assets/background.png")
  sp_background = love.graphics.newQuad(0, 0, 800, 600, image_background:getDimensions())

  image_background_live = love.graphics.newImage("assets/background_live.png")
  sp_background_live = love.graphics.newQuad(0, 0, 800, 600, image_background_live:getDimensions())

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  music = love.audio.newSource("assets/whispers_hero_1.mp3", "static")
  music2 = love.audio.newSource("assets/whispers_hero_2.mp3", "static")
  music3 = love.audio.newSource("assets/whispers_hero_3.mp3", "static")
  music4 = love.audio.newSource("assets/whispers_hero_4.mp3", "static")
  music5 = love.audio.newSource("assets/whispers_hero_5.mp3", "static")
  music6 = love.audio.newSource("assets/whispers_hero_6.mp3", "static")
  winner = love.audio.newSource("collide.wav", "static")
  looser = love.audio.newSource("collide.wav", "static")
end

function game_init()
  pourcent = 0
  progress = 0
  notes = {}
  song = require(string.format("assets/level_%d", current_level))
  mesure = 4*60/(song.tempo/6000)
  mesure2 = mesure * 2
  current_mesure = 0
  particles = {}

  for i,j in ipairs(song["notes"]) do
    table.insert(notes, get_note_sprite(j.time, j.note))
  end

  score_max = table.getn(notes)
  score = 0
  start = true


  time = 0
  love.audio.stop()
  if current_level == 1 then
    love.audio.play(music)
  elseif current_level == 2 then
    love.audio.play(music2)
  elseif current_level == 3 then
    love.audio.play(music3)
  elseif current_level == 4 then
    love.audio.play(music4)
  elseif current_level == 5 then
    love.audio.play(music5)
  elseif current_level == 6 then
    love.audio.play(music6)
  end

end

function add_win_particles(x, y)
  for i=1, 30 do
    particle = {}
    particle.x = x
    particle.y = y
    particle.a_x=love.math.random(-10, 10)
    particle.a_y=love.math.random(10, -10)
    table.insert(particles, particle)
  end
end

function get_note_sprite(time, val)
  note = {}
  note.x = - 100
  note.y = - 100
  note.speed = time
  note.value = val

  note.size = 64

  if note.value == 84 then
    note.star_x = a_start
    note.star_y = y_start
    note.dest_x = a_stop
    note.dest_y = y_stop
  elseif note.value == 86 then
    note.star_x = z_start
    note.star_y = y_start
    note.dest_x = z_stop
    note.dest_y = y_stop
  elseif note.value == 88 then
    note.star_x = e_start
    note.star_y = y_start
    note.dest_x = e_stop
    note.dest_y = y_stop
  elseif note.value == 89 then
    note.star_x = r_start
    note.star_y = y_start
    note.dest_x = r_stop
    note.dest_y = y_stop
  elseif note.value == 91 then
    note.star_x = t_start
    note.star_y = y_start
    note.dest_x = t_stop
    note.dest_y = y_stop
  end



  note.got = false
  return note
end

function game_getscore()
  return score, score_max
end

function game_update(dt)
  if table.getn(notes) < 1 then
    current_screen = current_screen + 1
  end

  for i, j in ipairs(particles) do
    j.x = j.x + j.a_x
    j.y = j.y + j.a_y
    j.a_y = j.a_y + 30 * dt
  end

  time = time + dt
  if love.keyboard.isDown("return") then
    game_init()
  end

  if love.keyboard.isDown("down") then
    start = false
  end

  result = 0

  if table.getn(notes)>0 then
    -- remove unchecked note
    if progress > notes[1].speed + 0.1 then
      if not notes[1].got then
        love.audio.play(looser)
      end
      table.remove(notes, 1)
    end
  end
  if table.getn(notes) > 0 then
    if ((progress > notes[1].speed - 0.1) and (progress < notes[1].speed + 0.1)) then
      if love.keyboard.isDown("a") and notes[1].value == 84 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("e") and notes[1].value == 86 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("t") and notes[1].value == 88 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("u") and notes[1].value == 89 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("o") and notes[1].value == 91 then
        notes[1].got = true
        score = score + 1
      -- else
      --   love.audio.play(looser)
      end
      if notes[1].got then
        add_win_particles(notes[1].x + notes[1].size/2, notes[1].y + notes[1].size/2)
        table.remove(notes, 1)
      end
    end
  end

  -- body...
  if start then
    progress = progress + dt
  end

  current_mesure = math.floor(progress / mesure)

  for i, test in ipairs(notes) do
      if test.speed - progress <= current_mesure * mesure2 + 2 * mesure2 then
        test.x = lerp(test.dest_x, test.star_x, (test.speed - progress))
        test.y = lerp(test.star_y, test.dest_y, 1 - (test.speed - progress))
        test.size = lerp(10, 64, 1 - (test.speed - progress))
      end
  end

  pourcent = score * 100 / score_max

end

function game_draw()
  -- love.graphics.print(string.format("x = %.1f ; y = %.1f ; t = %.1f", test.x, test.y, test.progress/test.speed))
  -- love.graphics.print(string.format("w = %d ; h = %d", width, height), 0, 100)
  love.graphics.setColor(1, 1, 1, 1)
  if current_level == 6 then
    love.graphics.draw(image_background_live, sp_background_live, 0, 0)
  else
    love.graphics.draw(image_background, sp_background, 0, 0)
  end
-- love.graphics.draw(tilesetImage, sp_floor, x*16, y*16)
  love.graphics.setColor(1, 1, 1, 1)
  -- if table.getn(notes)>0 then
  --   love.graphics.print(string.format("progress = %.2f; eg: %.1f", progress, notes[1].speed))
  -- end
  -- love.graphics.print(string.format("time = %.1f", time), 0, 25)
  -- love.graphics.print(string.format("position = %.1f", love.audio.getPosition(music)), 0, 50)
  -- love.graphics.print(string.format("array size = %d", table.getn(notes)), 0, 75)
  -- love.graphics.print(string.format("M = %.1f, M*2 = %.1f", mesure, mesure2), 0, 100)
  -- love.graphics.print(string.format("Current measure = %d", current_mesure), 0, 115)
  if pourcent <= 70 then
    love.graphics.setColor(192/255, 57/255, 43/255 , 0.9)
  elseif pourcent <= 95 then
    love.graphics.setColor(211/255, 84/255, 0/255 , 0.9)
  else
    love.graphics.setColor(46/255, 204/255, 113/255 , 0.9)
  end
  love.graphics.rectangle("fill", 20, 30, (760/100) * pourcent, 32)
  love.graphics.setColor(0.0, 0.0, 0.0, 1)
  love.graphics.rectangle("line", 20, 30, 760, 32)
  --love.graphics.print(string.format("SCORE = %d / %d", score, score_max), 50, 100)

  love.graphics.setColor(1, 1, 1, 0.8)
  love.graphics.line(a_start, y_start, a_stop, y_stop)
  love.graphics.line(z_start, y_start, z_stop, y_stop)
  love.graphics.line(e_start, y_start, e_stop, y_stop)
  love.graphics.line(r_start, y_start, r_stop, y_stop)
  love.graphics.line(t_start, y_start, t_stop, y_stop)
  love.graphics.line(a_stop, y_stop, t_stop, y_stop)

  for i, test in ipairs(notes) do
    --love.graphics.rectangle("line", test.x - test.size/2, test.y - test.size/2, test.size, test.size)
    if test.value == 84 then
      love.graphics.setColor(48/255, 204/255, 113/255,1)
    elseif test.value == 86 then
      love.graphics.setColor(192/255, 57/255, 43/255,1)
    elseif test.value == 88 then
      love.graphics.setColor(241/255, 196/255, 15/255,1)
    elseif test.value == 89 then
      love.graphics.setColor(52/255, 152/255, 219/255,1)
    elseif test.value == 91 then
      love.graphics.setColor(211/255, 84/255, 0,1)
    end
    love.graphics.circle("fill", test.x, test.y, test.size/2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", test.x, test.y, 2)
  end

  for i,j in ipairs(particles) do
    love.graphics.rectangle("fill", j.x, j.y, 2, 2)
  end

end

--float lerp (float a, float b, float t) { return a + t * (b - a); }
function lerp(a, b, t)
  return a * (1-t) + b * t
end

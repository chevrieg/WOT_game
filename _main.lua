-- local math = require "math"

function love.load()
 love.window.setTitle("WOT Hero")
  song = {
      tempo=600000,
      mesure = 4*60/(tempo/6000),
      mesure2 = mesure * 2,
      notes={
          {
              note=84,
              time=2.4
          },
          {
              note=86,
              time=2.7
          },
          {
              note=86,
              time=3.0
          },
          {
              note=88,
              time=3.31
          },
          {
              note=84,
              time=3.6
          },
          {
              note=84,
              time=4.2
          },
          {
              note=91,
              time=4.8
          },
          {
              note=91,
              time=5.79
          },
          {
              note=88,
              time=5.85
          },
          {
              note=89,
              time=6.0
          },
          {
              note=88,
              time=6.9
          },
          {
              note=86,
              time=7.05
          },
          {
              note=88,
              time=7.2
          },
          {
              note=84,
              time=7.8
          },
          {
              note=84,
              time=9.6
          },
          {
              note=84,
              time=9.94
          },
          {
              note=86,
              time=10.21
          },
          {
              note=89,
              time=10.65
          },
          {
              note=89,
              time=10.85
          },
          {
              note=91,
              time=11.4
          },
          {
              note=91,
              time=12.0
          },
          {
              note=91,
              time=12.9
          },
          {
              note=89,
              time=13.06
          },
          {
              note=89,
              time=13.2
          },
          {
              note=91,
              time=15.9
          },
          {
              note=89,
              time=16.05
          },
          {
              note=89,
              time=16.24
          },
          {
              note=88,
              time=16.51
          },
          {
              note=89,
              time=16.84
          },
          {
              note=88,
              time=17.12
          },
          {
              note=88,
              time=17.4
          },
          {
              note=88,
              time=17.72
          },
          {
              note=89,
              time=18.04
          },
          {
              note=88,
              time=18.33
          },
          {
              note=86,
              time=18.65
          },
          {
              note=88,
              time=18.96
          },
          {
              note=84,
              time=19.2
          },
          {
              note=84,
              time=20.4
          },
          {
              note=86,
              time=21.63
          },
          {
              note=88,
              time=24.01
          },
          {
              note=91,
              time=25.2
          },
          {
              note=84,
              time=26.4
          }
      }
  }
  particles = {}
  notes = {}
  for i,j in ipairs(song["notes"]) do
    table.insert(notes, get_note_sprite(j.time, j.note))
  end

  score_max = table.getn(notes)
  score = 0

  start = false

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  music = love.audio.newSource("whispers_hero.mp3", "static")
  winner = love.audio.newSource("collide.wav", "static")
  looser = love.audio.newSource("collide.wav", "static")

  progress = 0
  time = 0
end

function add_win_particles(x, y)
  for i=1, 10 do
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
  note.x = 700
  note.y = 170
  note.speed = time
  note.value = val

  note.size = 16

  if note.value == 84 then
    y = 440
  elseif note.value == 86 then
    y = 380
  elseif note.value == 88 then
    y = 320
  elseif note.value == 89 then
    y = 260
  elseif note.value == 91 then
    y = 200
  end

  note.star_x = 400 + 300
  note.star_y = y

  note.dest_x = 400 - 300
  note.dest_y = y

  note.got = false
  return note
end

function love.update(dt)
  for i, j in ipairs(particles) do
    j.x = j.x + j.a_x
    j.y = j.y + j.a_y
    j.a_y = j.a_y + 30 * dt
  end

  time = time + dt
  if love.keyboard.isDown("escape") then
    love.window.close()
  end

  if love.keyboard.isDown("space") then
    progress = 0
    start = true
    love.audio.play(music)
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
      elseif love.keyboard.isDown("z") and notes[1].value == 86 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("e") and notes[1].value == 88 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("r") and notes[1].value == 89 then
        notes[1].got = true
        score = score + 1
      elseif love.keyboard.isDown("t") and notes[1].value == 91 then
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

  for i, test in ipairs(notes) do
      test.x = lerp(test.star_x, test.dest_x, progress/test.speed)
      test.y = lerp(test.star_y, test.dest_y, progress/test.speed)
  end
end

function love.draw()
  -- love.graphics.print(string.format("x = %.1f ; y = %.1f ; t = %.1f", test.x, test.y, test.progress/test.speed))
  -- love.graphics.print(string.format("w = %d ; h = %d", width, height), 0, 100)
  if table.getn(notes)>0 then
    love.graphics.print(string.format("progress = %.2f; eg: %.1f", progress, notes[1].speed))
  end
  love.graphics.print(string.format("time = %.1f", time), 0, 25)
  love.graphics.print(string.format("position = %.1f", love.audio.getPosition(music)), 0, 50)
  love.graphics.print(string.format("array size = %d", table.getn(notes)), 0, 75)
  love.graphics.print(string.format("SCORE = %d / %d", score, score_max), 0, 100)
  for i, test in ipairs(notes) do
    --love.graphics.rectangle("line", test.x - test.size/2, test.y - test.size/2, test.size, test.size)
    if not test.got then
      love.graphics.setColor(52/255, 152/255, 219/255,1.0)
    else
      love.graphics.setColor(219/255, 152/255, 52/255,1.0)
    end
    love.graphics.circle("fill", test.x, test.y, test.size/2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("fill", test.x, test.y, 2)
  end

  for i,j in ipairs(particles) do
    love.graphics.rectangle("fill", j.x, j.y, 2, 2)
  end

  love.graphics.line(100, 180, 100, 460)
  love.graphics.line(400, 180, 400, 460)
  love.graphics.line(700, 180, 700, 460)

  -- Draw Note line
  -- 120 & 200
  for i=200, 440, 60 do
    love.graphics.line(0, i, 800, i)
  end
end

--float lerp (float a, float b, float t) { return a + t * (b - a); }
function lerp(a, b, t)
  return a * (1-t) + b * t
end

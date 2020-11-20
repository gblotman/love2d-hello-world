function love.load()
  NBSP = "\194\160"
  -- love.window.setFullscreen(true, "desktop")
  player = {}
  player.x = 25
  player.y = 5
  player.rotation = 0
  player.speed = 0
  player.str = NBSP:rep(1)..'Hello World!'
  
  fire = {}
  fire.str = '>==>'
  fire.onscreen = false
  fire.x = player.x
  fire.y = player.y
  fire.rotation = player.rotation
  fire.speed = 400

  explotion = {}
  explotion.str='O'
  explotion.onscreen = false
  explotion.x = love.graphics.getWidth()/2
  explotion.y = love.graphics.getHeight()/2
  explotion.rotation = 0
  explotion.frames = 0
  explotion.particles = {}
  for i=0,7 do
    explotion.particles[i] = {}
    explotion.particles[i].str = '-'
    explotion.particles[i].x = 0
    explotion.particles[i].y = 0
    explotion.particles[i].rotation = 0
    explotion.particles[i].speed = 500
    explotion.particles[i].onscreen = false
  end
end

function love.update(dt)
  handlePlayerControl(player)
  handleFireControl(fire, player, dt)
  moveForward(player,dt)
end

function love.draw()
  -- love.graphics.print('x:'..x..'\ny:'..y..'\nspeed:'..speed..'\nangle:'..rotation, 2, 2)
  love.graphics.print(player.str, player.x, player.y, player.rotation,1,1,10)
  if fire.onscreen then
    love.graphics.print(fire.str, fire.x, fire.y, fire.rotation)
  end
  if explotion.onscreen then
    love.graphics.print(explotion.str, explotion.x, explotion.y, explotion.rotation)
  end
  for i=0,7 do
    if explotion.particles[i].onscreen then
      love.graphics.print(explotion.particles[i].str, explotion.particles[i].x, explotion.particles[i].y, explotion.particles[i].rotation)
    end
  end
end

function explode(explotion, dt)
  explotion.frames = explotion.frames + 1
  if explotion.frames < 90 then
    explotion.onscreen = true
  elseif explotion.frames == 90 then
    explotion.onscreen = false
    speed = 500
    radians = 0
    for i=0,7 do
      explotion.particles[i].x = explotion.x
      explotion.particles[i].y = explotion.y
      explotion.particles[i].rotation = radians
      explotion.particles[i].onscreen = true
      radians = radians+0.785398
    end
  elseif explotion.frames > 90 then
    stillOnScreen = false
    for i=0,7 do
      explotion.particles[i].onscreen = checkOnScreen(explotion.particles[i]);
      if explotion.particles[i].onscreen then
        moveForward(explotion.particles[i] ,dt)
      end
    end
  end
end

function handleFireControl(fire, player, dt)
  if love.keyboard.isDown("space") and not fire.onscreen then
    fire.onscreen = true
    fire.x = player.x + math.cos(player.rotation)*60
    fire.y = player.y + math.sin(player.rotation)*60
    fire.rotation = player.rotation
  end
  if fire.onscreen then
    moveForward(fire,dt)
    fire.onscreen = checkOnScreen(fire)
  end
  if love.keyboard.isDown("return") then
    fire.onscreen = false
    explotion.x = fire.x
    explotion.y = fire.y
    explotion.frames = 0;
    explode(explotion, dt)
  end
end

function checkOnScreen(character)
  if character.x > love.graphics.getWidth() or character.x < 0 or character.y > love.graphics.getHeight() or character.y < 0 then
    return false
  end
  return true
end

function handlePlayerControl(player)
  if love.keyboard.isDown("right") then
    if(player.rotation > 6.2) then
      player.rotation = 0;
    end
    player.rotation = player.rotation + 0.05
  end
  if love.keyboard.isDown("left") then
    if(player.rotation < 0) then
      player.rotation = 6.2;
    end
    player.rotation = player.rotation - 0.05
  end
  if love.keyboard.isDown("up") and player.speed < 200 then
    player.speed = player.speed + 10
  end
  if love.keyboard.isDown("down") and player.speed > 0 then
    player.speed = player.speed - 10
  end
  if player.speed > 0 then
    player.str = '=Hello World!'
    player.speed = player.speed - 0.5
  else
    player.str = NBSP:rep(1)..'Hello World!'
  end
end

function moveForward(character,dt)
  character.x = character.x + math.cos(character.rotation) * character.speed * dt
  character.y = character.y + math.sin(character.rotation) * character.speed * dt
end
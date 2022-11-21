local player = {
    x = 300,
    y = 300,
    speed = 100,
}

function Length(vec)
    local v = vec.x * vec.x + vec.y * vec.y
    return math.sqrt(v)
end

function Normalize(vec)
    local l = Length(vec)
    if l == 0 then
        return vec
    end
    return {
        x = vec.x / l,
        y = vec.y / l,
    }
end

function Scale(vec, s)
    return {
        x = vec.x * s,
        y = vec.y * s
    }
end

function HandleKeyboard()
    local dir = { x = 0, y = 0 }
    if love.keyboard.isDown('w') then
        dir.y = -1
    end
    if love.keyboard.isDown('s') then
        dir.y = 1
    end
    if love.keyboard.isDown('a') then
        dir.x = -1
    end
    if love.keyboard.isDown('d') then
        dir.x = 1
    end

    return Normalize(dir)
end

function MouseDirection()
    local mx, my = love.mouse.getPosition()
    local dir = {
        x = mx - player.x,
        y = my - player.y
    }
    return Normalize(dir)
end

function love.load()
	tiles = love.graphics.newImage('tiles.png')
	
end

function love.update(dt)
    local dir = MouseDirection()
    local vel = Scale(dir, player.speed)
	if love.mouse.isDown(1)then
		player.x = player.x + vel.x * dt
		player.y = player.y + vel.y * dt
	end
end

function love.draw()
    love.graphics.circle("fill", player.x, player.y, 30)
	
	quad = love.graphics.newQuad(179,6,10,64,512,512)
	love.graphics.draw(tiles,quad,100,100)
end

--cd "C:/Program Files/LOVE"
--love.exe D:/Game
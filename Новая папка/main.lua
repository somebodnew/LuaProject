
local player = {
    x = 300,
    y = 300,
	dx = 0,
	dy = 0,
    speed = 100,
	tspeed = 0.01,
	r = 0
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
s = love.graphics.newImage('SpaceShips.png')
function love.update(dt)
    local dir = MouseDirection()
    local vel = Scale(dir, player.speed)
    player.r = player.r + player.tspeed
	
	if player.r > math.pi*2 then
		player.r = player.r - math.pi*2
	end
	if player.r < 0 then
		player.r = player.r + math.pi*2
	end
	
	if love.mouse.isDown(1)then
		player.Ax, player.Ay = love.mouse.getPosition()
		player.dx = player.Ax - player.x
		player.dy = -(player.Ay - player.y)
	end
end

function love.draw()
    love.graphics.draw(s, player.x, player.y, player.r)
	love.graphics.print(player.r,0,0)
	love.graphics.print(math.atan2(player.dx, player.dy),0,20)
end

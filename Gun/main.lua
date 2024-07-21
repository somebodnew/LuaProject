love.graphics.setDefaultFilter("nearest","nearest")

function love.load()
	-- assets
	gunPic = love.graphics.newImage('gun.png')
	bulletPic = love.graphics.newImage('bullet.png')
	targetPic = love.graphics.newImage('target.png')
	
	-- gun
	gun = {
		pic = gunPic,
		x = love.graphics.getWidth()/2,
		y = love.graphics.getHeight()/2,
		r = 0,
		scale = 2,
		bullet = bulletPic,
		speed = 0,
		vel = 100,
		maxSpeed = 100,
		dir = 1,
	}
	
	-- bullets
	bullets = {}
	
	-- target
	targets = {}
end

function love.update(dt)
	gunUpdate(gun,dt)
	projectileUpdate(bullets,dt)
	
end

function love.draw()
	drawObject(gun)
	for i, target in ipairs(targets)do
		drawObject(target)
	end
	for i, bullet in ipairs(bullets)do
		drawObject(bullet)
	end
	
	love.graphics.print(gun.r, 0,0)
	love.graphics.print(gun.speed, 0,20)
end

function love.keypressed(key)
	if key == 'space' then
		shoot(gun,bullets)
	end
	if key == 'return' then
		local x,y = love.mouse.getPosition()
		aim(targets,x,y,targetPic)
	end
end


function projectileUpdate(bullets,dt)
	for i, bullet in ipairs(bullets)do
		if bullet.speed > 0 then
			bullet.x = bullet.x + bullet.speed * math.cos(bullet.r)
			bullet.y = bullet.y + bullet.speed * math.sin(bullet.r)
			bullet.speed = bullet.speed - bullet.speed*0.1
		end
	end
end

function gunUpdate(gun,dt)
	if gun.r >= math.pi then
		gun.r = gun.r - 2 * math.pi
	end
	if gun.r <= -math.pi then
		gun.r = gun.r + 2 * math.pi
	end
	if gun.speed >= gun.maxSpeed then 
		gun.speed = gun.maxSpeed
	end
	if gun.speed <= gun.vel * dt then
		gun.speed = 0
	end
	gun.x = gun.x + gun.speed*math.cos(gun.r) * dt
	gun.y = gun.y + gun.speed*math.sin(gun.r) * dt
	if love.keyboard.isDown('up') then
		if gun.speed < gun.maxSpeed then
			gun.speed = gun.speed + gun.vel * dt
		end
	else
		if gun.speed > 0 then
			gun.speed = gun.speed - gun.vel * dt
		end
	end
    
	if love.keyboard.isDown('left') then
		gun.r = gun.r - 0.1
	end
	if love.keyboard.isDown('right') then
		gun.r = gun.r + 0.1
	end
end

function aim(targets,x,y,pic)
	local target = {
		x = x,
		y = y,
		r = math.random()*math.pi,
		shouldDestroy = -1,
		pic = pic,
		scale = math.random(3),	
	}
	table.insert(targets,target)
end

function shoot(gun,bullets)
	local bullet = {
		x = gun.x,
		y = gun.y,
		r = gun.r,
		pic = gun.bullet,
		speed = 20,
		scale = gun.scale - 1,
	}
	table.insert(bullets,bullet)
end

function drawObject(self)
	love.graphics.draw(self.pic,self.x,self.y,self.r,self.scale,self.scale,self.pic:getWidth()/2,self.pic:getHeight()/2)
end

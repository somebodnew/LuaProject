love.graphics.setDefaultFilter("nearest","nearest")
success = love.window.setMode( 700, 700)
liba = require('liba')

function love.load()
	bop = love.audio.newSource('assets/bop.wav','static')
	music = love.audio.newSource('assets/music.mp3','stream')
	music:setLooping(true)
	music:play()
	SpaceSheet = love.graphics.newImage('assets/SpaceShips.png')
	PortalSheet = love.graphics.newImage('assets/PortalSheet.png')
	EnemySheet = love.graphics.newImage('assets/EnemySheet.png')
	
	Timer = {
		nex = 0,
		timer = 0,
		c = 8,
		enemy = 6,
		et = 0
		}
	
	Stats = {}
	Stats[0] = {health = 5, dmg = 10, tspeed = 0.07,speed = 70, c = 0,nex = 10}
	Stats[1] = {health = 10, dmg = 2, tspeed = 0.1,speed = 70, c = 1,nex = 5}
	Stats[2] = {health = 7, dmg = 2, tspeed = 0.075,speed = 110, c = 2,nex = 3}
	Stats[3] = {health = 3, dmg = 8, tspeed = 0.04,speed = 100, c = 3,nex = 8}
	Stats[4] = {health = 1, dmg = 100, tspeed = 0.06,speed = 200, c = 4,nex = 4}
	Stats[5] = {health = 8, dmg = 5, tspeed = 0.05,speed = 100, c = 5,nex = 5}
	Stats[6] = {health = 6, dmg = 1, tspeed = 0.1,speed = 85, c = 6,nex = 3}
	Stats[7] = {health = 5, dmg = 5, tspeed = 0.09,speed = 110, c = 7,nex = 5}
	Stats[8] = {health = 10, dmg = 3, tspeed = 0.07,speed = 100, c = 8,nex = 4}
	Stats[9] = {health = 7, dmg = 4, tspeed = 0.08,speed = 80, c = 9,nex = 6}
	
	
	pos = {}
	pos[0] = {x = 0, y = 0}
	pos[1] = {x = 700, y = 0}
	pos[2] = {x = 700, y = 700}
	pos[3] = {x = 0, y = 700}
	
	Enemies = {}
	Ships = {}
	currentShip = 8
	
	Portal = {
		x = love.graphics.getWidth( )/2,
		y = love.graphics.getHeight( )/2,
		timer = 5,
		c = 0,
		pic = love.graphics.newQuad(0,0,16,16,512,32),
		killcount = 0,
		health = 5}
end



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

function Direction(ship)
    
    dir = {
        x = ship.Ax - ship.x,
        y = ship.Ay - ship.y
    }
    return Normalize(dir)
end

function CreateEnemy(et)
	local dest = {}
	dest[0] = {Ax = 700 - math.random(100),Ay = 700 - math.random(100)}
	dest[1] = {Ax = 0 + math.random(400),Ay = 700 - math.random(300)}
	dest[2] = {Ax = 0 + math.random(600),Ay = 0 - math.random(100)}
	dest[3] = {Ax = 350,Ay = 350}
	
	s = {
		x = et.x,
		y = et.y,
		timer = 0,
		r = math.random(-math.pi,math.pi),
		speed = 50,
		dest = dest,
		mark = math.random(4)-1,
		pic = love.graphics.newQuad(0,0,16,16,16,64),
		c = 0,
		
		dmg = 1,
		health = 3
	}
	s.Ax = s.dest[s.mark].Ax
	s.Ay = s.dest[s.mark].Ay
	return s
end

function love.update(dt)

    for i,a in ipairs(Ships) do
		liba.ShipUpdate(a,dt,currentShip)
		
		
	end
	for i,b in ipairs(Enemies) do
		b.speed = math.random(50,100)
		ra = math.random(1000)
		if ra <= 15 then
			b.Ax = math.random(700)
			b.Ay = math.random(700)
		end
		b.timer = b.timer + 5*dt
		b.r = b.r + 0.01
		if b.timer >= 5 then
			b.timer = b.timer - 5
			b.c = (b.c+1)%4
			b.pic = love.graphics.newQuad(0,16*b.c,16,16,16,64)
		end
		if b.Ax ~= b.x or b.Ay ~= b.y then
			local dir = Direction(b)
			local vel = Scale(dir, b.speed)
			b.x = b.x + vel.x * dt
			b.y = b.y + vel.y * dt
		end
		if b.Ax < b.x+2 and b.x-2 < b.Ax and b.Ay < b.y+2 and b.y-2 < b.Ay then
			b.x = b.Ax
			b.y = b.Ay
		end
		if (b.x == b.Ax and b.y == b.Ay)then
			b.mark = math.random(4)-1
			b.r = math.random(-math.pi,math.pi)
			b.Ax = b.dest[b.mark].Ax
			b.Ay = b.dest[b.mark].Ay
		end
		
	end
	if Portal.timer > 0 then
		Portal.timer = Portal.timer - dt*100
	else
		Portal.c = (Portal.c + 1)%16
		
		Portal.timer = Portal.timer + 5
	end
	
	if Timer.nex == 0 then
		local ship = liba.ShipCreate(Stats[Timer.c])
		table.insert(Ships,ship)
		bop:play()
		local p = love.math.random(10)-1
		Timer.c = p
		Timer.nex = Stats[p].nex
		Timer.timer = 0
	end
	Timer.enemy = Timer.enemy + dt*3
	Timer.timer = Timer.timer + dt*7
	if Timer.enemy > 3 then
		Timer.enemy = Timer.enemy - 3
		table.insert(Enemies, CreateEnemy(pos[Timer.et]))
		Timer.et = (Timer.et + math.random(3))%4
	end
	if Timer.timer > 3 then
		Timer.timer = Timer.timer - 3
		Timer.nex = Timer.nex - 1
	end
	
end
function love.keypressed(key)
	if key == 'tab'then
		currentShip = (currentShip+1)%11
	end
	if key == 'space'then
		music:stop()
		love.load()
	end

end
function love.draw()
	love.graphics.draw(PortalSheet,love.graphics.newQuad(Portal.c*32,0,32,32,512,32),Portal.x,Portal.y,0,3,3,16,16)
	for i,b in ipairs(Enemies) do
		love.graphics.draw(EnemySheet, b.pic, b.x,b.y,b.r, 2, 2,8,8)
	end
	for i,a in ipairs(Ships) do
		liba.ShipDraw(a,SpaceSheet)
	end
	love.graphics.rectangle('line',2,2,240,40)
	love.graphics.print('Summoning',5,5,0,2,2)
	love.graphics.draw(SpaceSheet, love.graphics.newQuad(16,16*Timer.c,16,16,32,176), 170,0,0, 2, 2,8,-3)
	love.graphics.print('In '..Timer.nex,190,5,0,2,2)
	love.graphics.rectangle('line',2,42,240,40)
	love.graphics.print('Tab: Control     LMB',5,45,0,2,2)
	love.graphics.draw(SpaceSheet, love.graphics.newQuad(16,16*currentShip,16,16,32,176), 170,40,0, 2, 2,8,-3)
	love.graphics.print('Restart on "SPACE" ',5,80,0,2,2)
	end

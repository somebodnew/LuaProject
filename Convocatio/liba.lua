local function ShipCreate(stat)
	
	s = {
		-- Некоторые свойств, состояния корабля
		shipType = stat.c,
		health = stat.health,
		dmg = stat.dmg,
		
		-- это координаты штуки и координаты куда он направляется
		x = love.graphics.getWidth( )/2,
		y = love.graphics.getHeight( )/2,
		Ax = love.graphics.getWidth( )/2+(math.random(stat.speed)-30)*(math.random(3)-2),
		Ay = love.graphics.getHeight( )/2+(math.random(stat.speed)-30)*(math.random(3)-2),
		-- угол поворота и координаты для просчета нового угла
		r = 0, 
		dx = 0, 
		dy = 0,
		phi = 0,
		cw = 1,
		-- Скорость разворота и скорость полета
		tspeed = stat.tspeed,
		speed = stat.speed,
		-- картинки, когда выбран и нет
		hpic = love.graphics.newQuad(16,16*stat.c,16,16,32,176),
		pic = love.graphics.newQuad(0,16*stat.c,16,16,32,176),
		-- вектора направления и ускорения
		dir = { x = 0, y = 0 },
		vel = { x = 0, y = 0 }
	}
	-- отображаемая картинка
	s.Cpic = s.pic
	return s
end
local function ShipUpdate(ship,dt,currentShip)
	if currentShip == 10 or ship.shipType == currentShip then
		ship.Cpic = ship.hpic
	else
		ship.Cpic = ship.pic
	end
-- назначение нового направления для штуки
	if love.mouse.isDown(1) and (currentShip == 10 or ship.shipType == currentShip) then
		local x,y = love.mouse.getPosition()
		ship.Ax = x + (math.random(ship.speed)-20)*(math.random(3)-2)
		ship.Ay = y + (math.random(ship.speed)-20)*(math.random(3)-2)
		ship.dx = ship.Ax - ship.x
		ship.dy = -(ship.Ay - ship.y)
		
		if ship.phi >=0 then
			if ship.phi-math.pi < math.atan2(ship.dx, ship.dy) and math.atan2(ship.dx, ship.dy)<=ship.phi then
				ship.cw = 1
			else
				ship.cw = -1
			end
		else 
			if ship.phi < math.atan2(ship.dx, ship.dy) and math.atan2(ship.dx, ship.dy)<=ship.phi+math.pi then
				ship.cw = 1
			else
				ship.cw = -1
			end
		
		end
		ship.phi = math.atan2(ship.dx, ship.dy)
	end
	-- поворот
	
	if ship.r ~= math.atan2(ship.dx, ship.dy) then
		ship.r = (ship.r + ship.tspeed*ship.cw)
	end
	if ship.r > math.pi then
		ship.r = ship.r - math.pi*2
	end
	if ship.r < -math.pi then
		ship.r = ship.r + math.pi*2
	end
	if math.atan2(ship.dx, ship.dy)-0.15 < ship.r and ship.r < math.atan2(ship.dx, ship.dy)+0.15 then
		ship.r = math.atan2(ship.dx, ship.dy)
	end
	
	-- движение
	if ship.Ax ~= ship.x or ship.Ay ~= ship.y then
		ship.dir = Direction(ship)
		ship.vel = Scale(ship.dir, ship.speed)
		ship.x = ship.x + ship.vel.x * dt
		ship.y = ship.y + ship.vel.y * dt
	end
	if ship.Ax < ship.x+2 and ship.x-2 < ship.Ax and ship.Ay < ship.y+2 and ship.y-2 < ship.Ay then
		ship.x = ship.Ax
		ship.y = ship.Ay
	end
end

local function ShipDraw(ship)
	love.graphics.draw(SpaceSheet, ship.Cpic, ship.x, ship.y, ship.r, 2, 2,8,8)

end

return{
	ShipCreate = ShipCreate,
	ShipUpdate = ShipUpdate,
	ShipDraw = ShipDraw,
}
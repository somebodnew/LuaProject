local aims = {}
-- Список для квадратов

local timer = 0
local cooldown = 0.5
-- Кулдаун

local count = 0
-- Счет

local lives = 1
-- Жизни

local isMouseClicked = false






function AimGen()

	hw = love.math.random(20,30 )
	-- Стороны квадратов
	
	
	-- Положение по х
	
	local aim = {x = love.math.random(10,790 ),y = 0,
		width = hw,
		height = hw,
		speed = 200,
		ShouldDestroy = false,
		
		r = love.math.random(),
		g =love.math.random(),
		b =love.math.random(),
		-- Цвет
		}
		
	table.insert(aims,aim)

end
-- Генерация квадратов в список		


function AimShoot(self,i)
	
	mx = love.mouse.getX()
	my = love.mouse.getY()
	-- Координаты курсора при нажатии
		
	if love.mouse.isDown(1) then 
		if not(isMouseClicked)and (self.x + self.width >= mx) and (mx >= self.x) and (self.y + self.height >= my) and (my >= self.y) then
			count = count + 1
			isMouseClicked = true
			self.ShouldDestroy = true
			-- Помечение квадратов, чтобы они потом удалились, если мышкой по ним попали
		end
	else
		isMouseClicked = false
	
	end
		
end


function AimDraw(self)

	love.graphics.setColor(self.r,self.g,self.b)
	
	love.graphics.rectangle("fill",
		self.x,
		self.y,
		self.width,
		self.height
		)

end
-- Отрисовка квадрата


function AimUpdate(self,dt)
	self.y = self.y + self.speed * dt
	-- Падение квадратов
	
	if self.y > 700 then
		lives = lives - 1
		self.ShouldDestroy = true
		-- Уменьшение жизни и удаление квадратов, если квадраты выпали с экрана
	end
end


function love.update(dt)
	if lives >= 0 then
		
		
		
		timer = timer - dt
		if timer <= 0 then
			timer = cooldown
			AimGen()
		end
		-- Кулдаун
		
		
		for i, a in ipairs(aims) do
			AimUpdate(a, dt)
			AimShoot(a,i)
			if a.ShouldDestroy == true then
				table.remove(aims,i) -- если второго аргумента нет, то удаляются все сразу 
			end
		end
		-- Обновление для каждого квадрата
		
	else
		love.graphics.setColor(1,1,1)
		love.graphics.print("GAME OVER",200,75)
		table.remove(aims)
	end
end

function love.draw()
	
	for _, a in ipairs(aims) do
		AimDraw(a)
		
	end
	
	
	love.graphics.setColor(1,1,1)
	love.graphics.print(count,100,30)
	-- Вывод счета
	
end
-- Отрисовка всех квадратов










--cd "C:/Program Files/LOVE"
--love.exe D:/Game
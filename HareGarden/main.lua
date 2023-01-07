love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 15
VerCell = 10

local Board = {width = tile*HorCell,height = tile*VerCell,Pressed = false,tile = tile,tx = tile/2,ty = tile/2,Grown = false}

-- Размер экрана
success = love.window.setMode(Board.width,Board.height)

-- Библиотеки
local anim = require('anim')
local field = require('field')

-- Загрузка спрайтшита
Hare = love.graphics.newImage('assets/HareSheet.png')
Carrot = love.graphics.newImage('assets/CarrotSheet.png')



-- Начальное положение игрока и костыль
local player = {
	x = tile/2,
	y = tile/2
}
local playerAnimation = {
	
}
local VegActive = {
	
}

-- Движение персонажа
-- Проверяет костыль, затем перемещает персонажа в зависимости от нажатой кнопки

function Move(self,board)
	if board.Pressed == false then
		if love.keyboard.isDown('s') and self.y + tile*2 < Board.height then
			self.y = self.y + tile
			board.Pressed = true
		end
		if love.keyboard.isDown('w') and self.y - tile > 0 then
			self.y = self.y - tile
			board.Pressed = true
		end
		if love.keyboard.isDown('d') and self.x + tile*2 < Board.width then
			self.x = self.x + tile
			board.Pressed = true
		end
		if love.keyboard.isDown('a') and self.x - tile > 0 then
			self.x = self.x - tile
			board.Pressed = true
		end
	end
end

-- Засадка семян
function Plant(self,board)
	if board.Pressed == false then
		if love.keyboard.isDown('space') then
			PlantCell(cells,player)
			board.Pressed = true
		end
	end
end

function GrowVeg(self,board)

	Veg = {
	x = board.tx,
	y = board.ty,
	}
	
	table.insert(self,Veg)
end

-- Костыль: после хода переменная Pressed становится истинной, тогда при следующей итерации ход не осуществится, пока не сработает следующая функция
-- Если кнопка не нажата, то Pressed становится ложной 
function EndTurn(board)
	
	if  board.Pressed == true and love.keyboard.isDown('w','a','s','d','space') == false then
		board.Pressed = false
		field.CellUpdate(cells,board)
		if board.Grown == true then
			board.Grown = false
			GrowVeg(VegActive,board)
		end
	end
	
end
	

	
-- Анимации зайца
function EntityDraw(animation,Pic,x,y)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		Pic, frame, 
		x, y
		)
end





function love.load()
	
	playerAnimation.idle = anim.idle(0,7,55,47,Hare)
	playerAnimation.current = playerAnimation.idle
	carrotAnimation = anim.idle(0,11,54,54,Carrot)
	cells = field.GenCells(HorCell-2,VerCell-2,tile)
end



function love.update(dt)
	
	Move(player,Board)
	Plant(player,Board)
	EndTurn(Board)
	anim.update(playerAnimation.current, dt)
	
	anim.update(carrotAnimation, dt)
	
	
end


function love.draw()
	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.rectangle('fill',0,0,Board.width,Board.height)
	field.DrawCells(tile,cells,HorCell-1,VerCell-1)
	love.graphics.setColor(1,1,1)
	EntityDraw(playerAnimation.current,Hare,player.x,player.y)
	
	for i, a in ipairs(VegActive)do
		EntityDraw(carrotAnimation,Carrot,a.x,a.y)
	end
	
end
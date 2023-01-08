love.graphics.setDefaultFilter("nearest","nearest")

-- Масштаб клетки
local tile = 54

HorCell = 15
VerCell = 10

-- Параметры поля и мира
local Board = {
	width = tile*(HorCell),
	height = tile*(VerCell),
	Pressed = false,
	tile = tile,
	Grown = false
	}

-- Размер экрана через размеры поля
success = love.window.setMode(Board.width,Board.height)

-- Библиотеки
local anim = require('anim')
local field = require('field')

-- Загрузка спрайтшита
Hare = love.graphics.newImage('assets/HareSheet.png')
Carrot = love.graphics.newImage('assets/CarrotSheet.png')

-- Игрок, его анимации и овощи
local player = {
	up = 'w',
	left = 'a',
	down = 's',
	right = 'd',
	x = tile/2,
	y = tile/2
}
local playerAnimation = {
	
}
local VegActive = {
	
}


-- Движение сущности на клавиши
-- Проверяет костыль, затем перемещает персонажа в зависимости от нажатой кнопки
function Move(self,board)
	if board.Pressed == false then
			-- первая часть условия на выяснение нажатой клавиши, а вторая часть условия для проверки границ
		if love.keyboard.isDown(self.up) and self.y - tile > 0 then
			self.y = self.y - tile
			board.Pressed = true
		end
		if love.keyboard.isDown(self.left) and self.x - tile > 0 then
			self.x = self.x - tile
			board.Pressed = true
		end
		if love.keyboard.isDown(self.down) and self.y + tile*2 < Board.height then
			self.y = self.y + tile
			board.Pressed = true
		end
		if love.keyboard.isDown(self.right) and self.x + tile*2 < Board.width then
			self.x = self.x + tile
			board.Pressed = true
		end
	end
end

-- Засадка семян
function Plant(self,cells,VegActive,board)
	if board.Pressed == false then
		if love.keyboard.isDown('space') then
			field.PlantCell(cells,player,VegActive)
			
			
			board.Pressed = true
		end
	end
end





-- Костыль: после хода переменная Pressed становится истинной, тогда при следующей итерации ход не осуществится, пока не сработает следующая функция
-- Если кнопка не нажата, то Pressed становится ложной 
function EndTurn(board)
		-- Проверяет, отпустил ли кнопку игрок после своего действия
	if  board.Pressed == true and love.keyboard.isDown('w','a','s','d','space') == false then
		board.Pressed = false
		-- После окончания действия игрока, начинается окончание хода, где происходят действия остальных вещей
		
		-- Функция обновляет состояние всех клеток с семенами - они сокращают свой таймер, приближая вырастание морковок
		field.CellUpdate(cells,board)
		
		
		
		-- Если флаг Grown отмечен, убирает отметку и создает овощ
		if board.Grown == true then
			board.Grown = false
			GrowVeg(VegActive,board)
		end
	end
	
end
	

	
-- Отрисовка предмета или персонажа
-- - - - - - - -
-- animation - анимация предмета или сущности
-- Для предмета вводится его анимация висения в воздухе
-- Для персонажа вводится его текущая(current) анимация
-- - - - - - - -
-- pic - Картинка сущности или спрайтшит, с которого берутся кадры анимации
-- - - - - - - -
-- x и y - координаты отрисовки 
-- берутся из параметров отрисовываемой сущности
function EntityDraw(animation,pic,x,y)
	frame = anim.getFrame(animation) 
	love.graphics.draw(
		pic, frame, 
		x, y
		)
end


function BackgroundColor(Board)
	love.graphics.setColor(0.3,0.3,0.3)
	love.graphics.rectangle('fill',0,0,Board.width,Board.height)
end

function love.load()
	
	
	-- Анимация всех морковок
	carrotAnimation = anim.idle(0,11,54,54,Carrot)
	
	-- Задание анимации ничегонеделания для зайца-игрока и подготовка для смены анимаций при смене состояний
	playerAnimation.idle = anim.idle(0,7,55,47,Hare)
	playerAnimation.current = playerAnimation.idle
	
	-- Генерация поля
	cells = field.GenCells(HorCell-2,VerCell-2,tile)
end



function love.update(dt)
	-- Действие Игрока
	Move(player,Board) -- Передвижение игрока
	Plant(player,Board)-- Посадка семян
	
	-- Остальные события происходят при срабатывании этой функции, а она зависит от хода игрока
	EndTurn(Board)
	
	
	-- Апдейт анимаций
	anim.update(playerAnimation.current, dt)
	
	anim.update(carrotAnimation, dt)
	
	
end


function love.draw()
	-- Фон серый, видно только по краям
	BackgroundColor(Board)
	
	-- Отрисовка клеток
	field.DrawCells(tile,cells,HorCell-1,VerCell-1)
	
	-- Отрисовка зайца
	love.graphics.setColor(1,1,1)
	EntityDraw(playerAnimation.current,Hare,player.x,player.y)
	
	-- Отрисовка всех морковок
	for i, a in ipairs(VegActive)do
		EntityDraw(carrotAnimation,Carrot,a.x,a.y)
	end
	
	
end
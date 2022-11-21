
-- Предмет с координатами и скоростью
local player = {
    x = 300,
    y = 300,
    speed = 100,
}

-- Функция для вычисления длины вектора (Теорема Пифагора)
function Length(vec)
    local v = vec.x * vec.x + vec.y * vec.y
    return math.sqrt(v)
end


-- Функция для ??? что - то на умном языке
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


-- Изменение координат предмета через вектора
function Scale(vec, s)
    return {
        x = vec.x * s,
        y = vec.y * s
    }
end

-- Пока Не используется
-- Функция для изменения вектора движения с помощью WASD
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



-- Функция Для управления с помощью мышки
function MouseDirection()
    local mx, my = love.mouse.getPosition()
    local dir = {
        x = mx - player.x,
        y = my - player.y
    }
    return Normalize(dir)
end

-- Загрузка штук
function love.load()
	--tiles = love.graphics.newImage('tiles.png')
	
end

-- Обновление кадров
function love.update(dt)

	-- Для управление мышкой
    local dir = MouseDirection()
	
	-- Пока не используется 
	-- Для управления клавишами
	--local dir = HandleKeyboard() 
	
	
	-- Изменение 
    local vel = Scale(dir, player.speed)
	
	-- Движение, когда нажата ЛКМ
	if love.mouse.isDown(1) then -- Вот сюда проверку на расстояние между корсором и объектом
		player.x = player.x + vel.x * dt -- Изменение X
		player.y = player.y + vel.y * dt -- Изменение Y
		player.speed = player.speed + 10 * dt  -- Ускорение со временем
	else 
		player.speed = 100 -- Скорость сбрасывается до начальной, если отпускается кнопка
	end
end

function love.draw()
    love.graphics.circle("fill", player.x, player.y, 30)
	
	--quad = love.graphics.newQuad(179,6,10,64,512,512)
	--love.graphics.draw(tiles,quad,100,100)
end

--cd "C:/Program Files/LOVE"
--love.exe C:\Program Files\LOVE>love.exe C:\Users\1\Documents\GitHub\LuaProject\Project
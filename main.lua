function GenCells(HorCell,VerCell,tileSizeSize)
	cells = {}
	for i = 0, HorCell do
		for j = 0, VerCell do
			cell = {
			x = i*tileSize,
			y = j*tileSize, 
			r = love.math.random(),
			g =love.math.random(),
			b =love.math.random()}
			
			table.insert(cells, cell)
			
		end
	end
	
end

function DrawCells()

	for i,a in ipairs(cells) do 
		love.graphics.setColor(a.r,a.g,a.b)
		love.graphics.rectangle("fill",a.x,a.y,tileSize,tileSize)

	end
	
end

return {
	GenCells = GenCells
	DrawCells = DrawCells
}
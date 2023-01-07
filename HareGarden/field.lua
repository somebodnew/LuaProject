function GenCells(HorCell,VerCell,tileSize)
	cells = {}
	for i = 0, HorCell do
		for j = 0, VerCell do
			cell = {
			x = i*tileSize+tileSize/2,
			y = j*tileSize+tileSize/2, 
			r = love.math.random(),
			g =love.math.random(),
			b =love.math.random()}
			
			table.insert(cells, cell)
			
		end
	end
	return cells
end

function DrawCells(tileSize,cells)

	for l,a in ipairs(cells) do 
		love.graphics.setColor(a.r,a.g,a.b)
		love.graphics.rectangle("fill",a.x,a.y,tileSize,tileSize)

	end
	
end

return {
	GenCells = GenCells,
	DrawCells = DrawCells
}
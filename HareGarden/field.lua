function GenCells(HorCell,VerCell,tileSize)
	cells = {}
	for i = 0, HorCell do
		for j = 0, VerCell do
			local c = math.pow(-1,i)*math.pow(-1,j)
			cell = {
			x = i*tileSize+tileSize/2,
			y = j*tileSize+tileSize/2, 
			color = {c,c,c}}
			
			table.insert(cells, cell)
			
		end
	end
	return cells
end

function DrawCells(tileSize,cells)

	for l,a in ipairs(cells) do 
		love.graphics.setColor(a.color,a.color,a.color)
		love.graphics.rectangle("fill",a.x,a.y,tileSize,tileSize)

	end
	
end

return {
	GenCells = GenCells,
	DrawCells = DrawCells
}
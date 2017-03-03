game_map = {}
game_map = Gamestate()

function game_map:enter()
	--create title of area
	area_title = "South End"
	area_window = Window(screen.w/2, 0, 128, 96, nil, area_title)
end

function game_map:update(dt)
	Window.updateAll(dt)
	Object.updateAll(dt)
end

function game_map:draw()
	Window.drawAll()
	Object.drawAll()
end
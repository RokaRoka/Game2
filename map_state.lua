game_map = {}
debug_room = {}
game_map = Gamestate.new()
debug_room = Gamestate.new()

function game_map:init()
	--array enum
	--1 - Blank "Blank square."
	--2 - Snow "A tile for snow, the majority of the map."
	--3 - Road "A path that may lead somewhere"
	--4 - Grass "Not all of the ground is dirtied with the power of Winter"

	--initialize images
	texture = {}
	texture.img = love.graphics.newImage("Assets/Images/Textures/tilemap_outside.png")
	texture[1] = love.graphics.newQuad(0, 0, 64, 64, texture.img:getDimensions())
	texture.blank = texture[1]
	texture[2] = love.graphics.newQuad(64, 0, 64, 64, texture.img:getDimensions())
	texture.snow = texture[2]
	texture[3] = love.graphics.newQuad(128, 0, 64, 64, texture.img:getDimensions())
	texture.road = texture[3]
	texture[4] = love.graphics.newQuad(0, 64, 64, 64, texture.img:getDimensions())
	texture.grass = texture[4]

	map1 = { --maps are 14 by 10
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row1
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row2
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row3
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row4
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row5
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row6
		{2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2, 2, 4, 4},--row7
		{4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4},--row8
		{4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4},--row9
		{4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4} --row10
	}
end

function game_map:enter()
	--create world
	world = love.physics.newWorld(0, 0)
	--set callbacks
	world:setCallbacks(beginContact, endContact)

	BG_southend = createMapTileBatch(map1)
	
	--create player
	player = Player(500, 500)
	--create houses

	--create interactables
	NPC_npc1 = NPC(200, 100, 32, 32, {
		"Hi. What are you doing out here?",
		"It's kinda freezing. You should get inside.", 
		"I'm fine, I've got a really warm coat.",
		"There are many locals around. But they aren't really that friendly, good luck finding some heat."})

	--create title of area
	area_window = Window_Title("South End")

	--dialogue stuff
	Window_Dialogue.DW_Current = Window_Dialogue(
		{"... It is time to leave.",
		"... Home should be close by",
		"Walk. You can talk by using the Z key."}
	)
end

function game_map:update(dt)
	world:update(dt)
	Object.updateAll(dt)
	if Window_Dialogue.DW_Current then
		Window_Dialogue.DW_Current:update(dt)
	end
	--Window.updateAll(dt)
end

function game_map:draw()
	love.graphics.draw(BG_southend.sprBat, 0, 0)
	Object.drawAll()
	Window.drawAll()
	if Window_Dialogue.DW_Current then
		Window_Dialogue.DW_Current:draw()
	end
end

function debug_room:init()
	--array enum
	--1 - Blank "Blank square."
	--2 - Snow "A tile for snow, the majority of the map."
	--3 - Road "A path that may lead somewhere"
	--4 - Grass "Not all of the ground is dirtied with the power of Winter"

	--initialize images
	texture = {}
	texture.img = love.graphics.newImage("Assets/Images/Textures/tilemap_outside.png")
	texture[1] = love.graphics.newQuad(0, 0, 64, 64, texture.img:getDimensions())
	texture.blank = texture[1]
	texture[2] = love.graphics.newQuad(64, 0, 64, 64, texture.img:getDimensions())
	texture.snow = texture[2]
	texture[3] = love.graphics.newQuad(128, 0, 64, 64, texture.img:getDimensions())
	texture.road = texture[3]
	texture[4] = love.graphics.newQuad(0, 64, 64, 64, texture.img:getDimensions())
	texture.grass = texture[4]

	map1 = { --maps are 14 by 10
		{1, 2, 3, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row1
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row2
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
	}
end

function debug_room:enter()
	require("lightingShader")

	--create world
	world = love.physics.newWorld(0, 0)
	--set callbacks
	world:setCallbacks(beginContact, endContact)


	BG_debug = createMapTileBatch(map1) 

	--create player
	player = Player(50, 50)
	--create NPCS
	NPC_npc1 = NPC(200, 100, 32, 32, {"Hiya, I'm an NPC!", "I have an interesting life!"})
	--shaderPointLight:send("light_pos", {NPC_npc1.pos:unpack()})

	--create title of area
	area_window = Window_Title("Debug")

	--debug here
	--dialogue window(t_text, name)
	Window_Dialogue.DW_Current = Window_Dialogue(
		{"Hi! I am a test.",
		"Dialogue ain't easy, huh?"}
	)

end

function debug_room:update(dt)
	world:update(dt)
	Object.updateAll(dt)
	if Window_Dialogue.DW_Current then
		Window_Dialogue.DW_Current:update(dt)
	end
	--Window.updateAll(dt)
end

function debug_room:draw()
	love.graphics.draw(BG_debug.sprBat, 0, 0)
	Object.drawAll()
	Window.drawAll()
	if Window_Dialogue.DW_Current then
		Window_Dialogue.DW_Current:draw()
	end
end

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
	texture.img = love.graphics.newImage("Assets/Images/Textures/tile_snow.png")
	texture[1] = love.graphics.newQuad(0, 0, 64, 64, texture.img:getDimensions())
	texture.blank = texture[1]
	texture[2] = love.graphics.newQuad(64, 0, 64, 64, texture.img:getDimensions())
	texture.snow = texture[2]
	texture[3] = love.graphics.newQuad(0, 64, 64, 64, texture.img:getDimensions())
	texture.road = texture[3]
	texture[4] = love.graphics.newQuad(64, 64, 64, 64, texture.img:getDimensions())
	texture.grass = texture[4]

	map1 = { --maps are 14 by 10
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row1
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row2
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row3
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row4
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row5
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row6
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row7
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row8
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row9
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1} --row10
	}
end

function game_map:enter()
	--create world
	world = love.physics.newWorld(0, 0)

	BG_southend = createMapTileBatch(map1) 
	--[[
	--create textures
	firstSnow = {}
	firstSnow.sprBat = love.graphics.newSpriteBatch(texture.snow, 16, "static")
	--first row
	firstSnow.tL = firstSnow.sprBat:add(0, 0)
	firstSnow.tM1 = firstSnow.sprBat:add(64, 0)
	firstSnow.tM2 = firstSnow.sprBat:add(64 + 64, 0)
	firstSnow.tR = firstSnow.sprBat:add(64 + 64 + 64, 0)
	--second row
	firstSnow.mL = firstSnow.sprBat:add(0, 64)
	firstSnow.mM1 = firstSnow.sprBat:add(64, 64)
	firstSnow.mM2 = firstSnow.sprBat:add(64 + 64, 64)
	firstSnow.mR = firstSnow.sprBat:add(64 + 64 + 64, 64)
	--third row
	firstSnow.m2L = firstSnow.sprBat:add(0, 64 + 64)
	firstSnow.m2M1 = firstSnow.sprBat:add(64, 64 +64)
	firstSnow.m2M2 = firstSnow.sprBat:add(64 + 64, 64 + 64)
	firstSnow.m2R = firstSnow.sprBat:add(64 + 64 + 64, 64 + 64)
	--forth row
	firstSnow.bL = firstSnow.sprBat:add(0, 64 + 64 + 64)
	firstSnow.bM1 = firstSnow.sprBat:add(64, 64 + 64 + 64)
	firstSnow.bM2 = firstSnow.sprBat:add(64 + 64, 64 + 64 + 64)
	firstSnow.bR = firstSnow.sprBat:add(64 + 64 + 64, 64 + 64 + 64)
	]]
	--create player
	player = Player(50, 50)
	--create houses

	--create interactables

	--create title of area
	area_window = Window_Title("South End")

	--dialogue stuff
	Window_Dialogue.DW_Current = Window_Dialogue(
		{"Home... Come home now. It is time to leave.",
		"Do not make me wait...",
		"Walk. You can talk with the locals with the Z key."}
	)
end

function game_map:update(dt)
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


function createMapTileBatch(arrayData)
	local tileBatch = {}
	tileBatch.sprBat = love.graphics.newSpriteBatch(texture.img, 140, "static")
	for k, v in pairs(arrayData) do
		for j, i in pairs(v) do
			tileBatch.sprBat:add(texture[i], (j*64)-64, (k * 64) -64)
		end
	end

	return tileBatch
end

function debug_room:init()
	--array enum
	--1 - Blank "Blank square."
	--2 - Snow "A tile for snow, the majority of the map."
	--3 - Road "A path that may lead somewhere"
	--4 - Grass "Not all of the ground is dirtied with the power of Winter"

	--initialize images
	texture = {}
	texture.img = love.graphics.newImage("Assets/Images/Textures/tile_snow.png")
	texture[1] = love.graphics.newQuad(0, 0, 64, 64, texture.img:getDimensions())
	texture.blank = texture[1]
	texture[2] = love.graphics.newQuad(64, 0, 64, 64, texture.img:getDimensions())
	texture.snow = texture[2]
	texture[3] = love.graphics.newQuad(0, 64, 64, 64, texture.img:getDimensions())
	texture.road = texture[3]
	texture[4] = love.graphics.newQuad(64, 64, 64, 64, texture.img:getDimensions())
	texture.grass = texture[4]

	map1 = { --maps are 14 by 10
		{1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},--row1
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

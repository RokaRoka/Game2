--It's Cold - A (narrative) personal project by Sam Scott
--This game is about someone just trying to get inside. It's cold out, you know?
--The player can walk around the world. They can talk. They can receive items.
--The world is built up with places/people to interact

--set up HUMP
Class = require("hump.class")
Gamestate = require("hump.gamestate")
vector = require("hump.vector")

--classes
--BASE CLASS - Debug
--PURPOSE - A base class for debuging information
--STATUS - MODERATELY FUNCTIONAL
Debug = Class{
	init = function(self, text)
		self.text = text
		self.drawable = true
	end
}

--BASE CLASS - Part
--PURPOSE - A base class for all complex object components (Animations, Quests, Hitboxes)
--STATUS - INCOMPLETE
Part = Class{
	init = function(self, parent, name)
		self.parent = parent
		self.name = name
		self.active = true

		self.debug = Debug("Part Created!")
	end
}

--BASE CLASS - Object
--PURPOSE - A base class for all  objects that appear in the world
--STATUS - MODERATELY FUNCTIONAL
Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		self.drawable = true

		--Leave an array for parts
		self.parts = {}

		self.obj_i = Object.obj_i + 1
		Object.all[self.obj_i] = self
		Object.obj_i = self.obj_i

		self.debug = Debug("Object "..self.obj_i.." Spawned!")
	end,
	all = {}, obj_i = 0,

	updateAll = function(dt)
		for i = 1, Object.obj_i do
			local current = Object.all[Object.obj_i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, Object.obj_i do
			local current = Object.all[Object.obj_i]
			--do this later, for now, draw hitboxes
			if current.drawable then
				current:draw()
			end
			if current.debug.drawable then
				love.graphics.rectangle("line", current.pos.x, current.pos.y, current.w, current.h)
			end
		end
	end
}

--CLASS - Image
--[[Purpose - To add visual flair or communicate debug information (such as walking)
to the player visually]]
--STATUS
--[[INFO:
	-filepath is FROM the images folder, since images should not be anywhere else within the game
	-IMAGES MUST BE PNG
]]
Image = Class{__includes = Part,
	init = function(self, parent, name, filepath)
		Part.init(self, parent, name)
		self.filepath = filepath
		self.image = nil

		self.loaded = false
	end

}

function Image:load()
	self.image = love.graphics.newImage("Assets/Images"..self.filepath..".png")
	self.loaded = true
end

function Image:draw()
	if self.loaded then love.graphics.draw(self.image, self.parent.pos.x, self.parent.pos.y) end
end

--CLASS - Animation
--[[Purpose - To add visual flair and communicate information (such as walking)
to the player visually]]
--STATUS
--[[INFO:
	-speed based on frames i.e. 1 speed = 1 image per frame, 0.5 speed = 1 image per 2 frames
	-file_path is FROM the images folder, since images should not be anywhere else within the game
	-ANIMATIONS MUST BE PNG
]] 
Animation = Class{__includes = Part,
	init = function(self, parent, name, filepath, frames, speed)
		Part.init(self, parent, name)
		self.filepath = filepath
		self.images = {}
		self.frames = frames
		self.speed = speed
		
		self.loaded = false
		self.current = 1
		self.playing = false
	end,
}

function Animation:load()
	for i = 1, self.frames do
		self.images[i] = love.graphics.newImage("Assets/Images"..self.filepath..i..".png")
	end
	self.loaded = true
end

function Animation:play()
	self.playing = true
end

function Animation:pause()
	self.playing = false
end

function Animation:draw()
	local current_frame = self.images[math.floor(self.current)]
	love.graphics.draw(current_frame, self.parent.pos.x, self.parent.pos.y)
	--if not playing, pause the frame
	if self.playing then
		self.current = self.current + (0.1 * self.speed)
		self.parent.debug.text = self.current
		if self.current > self.frames + 1 then self.current = 1 end
	end
end

--CLASS - Quest
--[[PURPOSE - Objects that control story beats.]]
--STATUS - INCOMPLETE
Quest = {__includes = Part,
	init = function(self, parent, name, requirement)
		Part.init(self, parent, name)
		self.requirement = requirement
	end
}

--TODO CLASS Background = Class{}

--CLASS - Player
--[[PURPOSE - Allows the player to interact with the game world and
enact most, if not all, mechanics]]
--MECHANICS - Walk (incomplete) and Talk (incomplete)
--STATUS - INCOMPLETE
Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)

		--test image for drawing (parent, name, filepath)
		--self.debug_img = Image(self, "DebugImage", "/Player/player_walk1")
		--self.debug_img:load()

		--walking anim
		self.currentAnim = nil
		--Anim (parent, name, filepath, frames, speed (discontinued))
		self.parts[1] = Animation(self, "Walk", "/Player/player_walk", 4, 0.75)
		self.parts[1]:load()
		self.currentAnim = self.parts[1]
		self.currentAnim:play()
	end,

	--player default values
	speed = 100
}

function Player:update(dt)
	self:walk(dt)
end

function Player:walk(dt)
	if love.keyboard.isDown('left') then
        self:move(dt, -1, 0)
    elseif love.keyboard.isDown('right') then
        self:move(dt, 1, 0)
    end
    if love.keyboard.isDown('up') then
        self:move(dt, 0, -1)
    elseif love.keyboard.isDown('down') then
        self:move(dt, 0, 1)
    end
end

function Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	delta:normalizeInplace()
	self.pos = self.pos + delta * self.speed * dt
end

function Player:draw()
	if self.debug_img and self.debug.drawable then
		self.debug_img:draw()
	elseif self.currentAnim then
		self.currentAnim:draw()
	end
	love.graphics.print(self.debug.text, 600, 10)
end

--Require files
require("color_shortcut")

--Require systems
--require("window")

function love.load()
	screen = {}
	screen.w, screen.h = love.graphics.getDimensions()

	--initialize images
	texture = {}
	texture.snow = love.graphics.newImage("Assets/Images/Textures/tile_snow.png")
	--create world
	world = love.physics.newWorld(0, 0)
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
	--create player
	player = Player(50, 50)
	--create houses

end

function love.update(dt)
	Object.updateAll(dt)
end

function love.draw()
	love.graphics.draw(firstSnow.sprBat, 0, 0)
	Object.drawAll()
end
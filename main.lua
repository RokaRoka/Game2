--It's Cold - A (narrative) personal project by Sam Scott
--This game is about someone just trying to get inside. It's cold out, you know?
--The player can walk around the world. They can talk. They can receive items.
--The world is built up with places/people to interact

--set up HUMP
Class = require("hump.class")
Gamestate = require("hump.gamestate")
vector = require("hump.vector")

--classes
Debug = Class{
	init = function(self, text)
		self.text = text
		self.drawable = true
	end
}

Object = Class{
	init = function(self, x, y, w, h, interact)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		--Interactable, if the object has it
		self.interact = interact or nil

		self.drawable = false

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
				--love.graphics.draw
			end
			if current.debug.drawable then
				love.graphics.rectangle("line", current.pos.x, current.pos.y, current.w, current.h)
			end
		end
	end
}

--TODO CLASS Background = Class{}

Player = Class{__includes = Object,
	init = function(self, x, y)
		Object.init(self, x, y, 32, 32)
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

--Require files
require("color_shortcut")

--Require systems
require("window")

--Gamestate scenes
titleScreen = {}
require("map_state") --game_map

function love.load()
	--make screen sizes accessible
	screen = {}
	--screen.w = t.window.width
	--screen.h = t.window.height
	Gamestate.registerEvents()
	Gamestate.switch(debug_room)
end

function love.update(dt)
	--Object.updateAll(dt)
end

function love.draw()
	--Object.drawAll()
end
--It's Cold - A (narrative) personal project by Sam Scott
--This game is about someone just trying to get inside. It's cold out, you know?
--The player can walk around the world. They can talk. They can receive items.
--The world is built up with places/people to interact

--set up HUMP
Class = require("hump.class")
Gamestate = require("hump.gamestate")
vector = require("hump.vector")
Signal = require("hump.signal")

--preliminary includes
require("collision_masks")
require("color_shortcut")

--Classes
require("baseClasses")
require("physicsClasses")
require("graphicsClasses")
require("interactable")

--Require systems
require("window")

--CLASS - Player
--[[PURPOSE - Allows the player to interact with the game world and
enact most, if not all, mechanics]]
--MECHANICS - Walk (getting there) and Talk (kinda works, need to seperate presses/holds)
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

		self.p_body.body:setType("dynamic")
		self.busy = false
		self.in_range_of = {}

		self.drawable = true
	end,

	--player default values
	speed = 100
}

function Player:update(dt)
	if not player.busy then
		self:walk(dt)
		self:checkAction(dt)
	end
end

function Player:walk(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown('left') then
        dx = -1
    elseif love.keyboard.isDown('right') then
        dx = 1
    end
    if love.keyboard.isDown('up') then
        dy = -1
    elseif love.keyboard.isDown('down') then
        dy = 1
    end
    self:move(dt, dx, dy)
end

function Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	
	self.p_body.body:setLinearVelocity(delta.x * self.speed * (dt * 100), delta.y * self.speed * (dt * 100))
	local newPx, newPy = self.p_body.body:getPosition()
	newPx = math.floor(newPx)
	newPy = math.floor(newPy)

	self.pos = vector.new(newPx, newPy)
	--if newPx ~= 0 or newPy ~= 0 then newShader:send("player_pos", player.pos:unpack()) end
	--self.pos = self.pos + delta * self.speed * dt
end

function Player:checkAction(dt)
	if self.in_range_of[1] and key_press.check("z") then
		self.debug.text = "Player talking!"
		self.in_range_of[1].interact:response()
	end
end

function Player:draw()
	if self.debug_img and self.debug.drawable then
		self.debug_img:draw()
	elseif self.currentAnim then
		self.currentAnim:draw()
	end
	love.graphics.print(self.debug.text, 600, 10)
end

NPC = Class{__includes = Object,
	init = function(self, x, y, w, h, dialogue)
		Object.init(self, x, y, w, h)
		--create trigger zone and pass to interactable
		self.p_trigger = PhysicsTrigger(self, self.p_body, "circle", self.w*1.25)

		self.parts[1] = Quest(self, "Key-Door1", false)
		self.interact = Talkable(self.p_trigger, dialogue, self.parts[1])
	end
}

function NPC:update(dt)
	--something
end

function NPC:draw()
	--draw npc?
end

--Gamestate scenes
titleScreen = {}
titleScreen = Gamestate.new()
require("map_state") --game_map

function love.load()
	--make screen sizes accessible
	screen = {}
	screen.w, screen.h = love.graphics.getDimensions()
	--screen.w = t.window.width
	--screen.h = t.window.height

	love.keyboard.setKeyRepeat(true)

	key_press = { a = false,
		b = false,
		c = false,
		d = false,
		e = false,
		f = false,
		g = false,
		h = false,
		i = false,
		j = false,
		k = false,
		l = false,
		m = false,
		n = false,
		o = false,
		p = false,
		q = false,
		r = false,
		s = false,
		t = false,
		u = false,
		v = false,
		w = false,
		x = false,
		y = false,
		z = false,
		check = function(key)
			if key_press[key] then
				key_press[key] = false
				return true
			else
				return false
			end
		end
	}

	Gamestate.registerEvents()
	Gamestate.switch(debug_room)
end

function love.update(dt)
	--Object.updateAll(dt)
end

function love.draw()
	--Object.drawAll()
end

function love.keypressed(key, scancode, isRepeat)
	if not isRepeat then
		key_press[key] = true
		player.debug.text = player.debug.text..key
	else
		key_press[key] = false
		player.debug.text = player.debug.text..key.." Held."
	end
end

function love.keyreleased(key, scancode, isRepeat)
	key_press[key] = false
	player.debug.text = key.." released."
end

--Physics engine callbacks
function beginContact(fixtureA, fixtureB, contact)
	--do player collisions
	if fixtureA == player.p_body.fixture or fixtureB == player.p_body.fixture then
		player.debug.text = "Colliding!"
		player.debug.color = {25, 25, 255, 255}
		if fixtureA == NPC_npc1.p_trigger.fixture or fixtureB == NPC_npc1.p_trigger.fixture then
			player.debug.text = "In range of npc1"
			player.in_range_of = {NPC_npc1}
		end
	end
end

function endContact(fixtureA, fixtureB, contact)
	--do player collision ends
	if fixtureA == player.p_body.fixture or fixtureB == player.p_body.fixture then
		player.debug.text = "Not colliding!"
		player.debug.color = {75, 75, 175, 255}
		if fixtureA == NPC_npc1.p_trigger.fixture or fixtureB == NPC_npc1.p_trigger.fixture then
			player.in_range_of = {}
		end
	end
end
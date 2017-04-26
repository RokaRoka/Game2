--CLASS - Image
--[[Purpose - To add visual flair or communicate debug information (such as walking)
to the player visually]]
--STATUS - WERE GETTING THERE
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

--TODO CLASS Background = Class{}
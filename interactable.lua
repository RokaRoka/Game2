Interactable = Class{
	init = function(self, range)
		self.range = range
	end
}

function Interactable:response()
	--Whether it is dialogue
end

Talkable = Class{__includes = Interactable,
	init = function(self, range, dialogue)
		Interactable.init(self, range)
		self.dialogue = dialogue
	end,
	Type = "Talkable"
}

Leverable = Class{__includes = Interactable,
	init = function(self, range)
		Interactable.init(self, range)
	end,
	Type = "Leverable"
}
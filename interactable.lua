Interactable = Class{
	init = function(self, range)
		self.range = range
		self.act_i = 1
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

function Talkable:response()
	Window_Dialogue.DW_Current = Window_Dialogue(self.dialogue)
end

Leverable = Class{__includes = Interactable,
	init = function(self, range)
		Interactable.init(self, range)
	end,
	Type = "Leverable"
}
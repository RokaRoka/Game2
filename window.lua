title_font = love.graphics.newFont(18)
Window = Class {
    init = function(self, x, y, w, h, winImg, title, text)
        --appearence
        self.pos = vector.new(x or 0, y or 0)
        self.w = w or screen.w; self.h = h or screen.h

        self.winImg = winImg or Window.img.default

        --spritebatch!
        self.windowBat = Window.windowSprBat(self.w, self.h, self.winImg)
        --self.arrow = love.graphics.newQuad(64+16, 16, 16, 16, raw_imgs.window.default:getDimensions())

        --strings

        self.title = love.graphics.newText(title_font, title)
        self.text = text

        --string info
        self.textHeight = love.graphics.getFont():getHeight()

        --Add window to onScreen array
        Window.onScreeni = #Window.onScreen + 1
        self.onScreeni = Window.onScreeni
        Window.onScreen[Window.onScreeni] = self

    end,

    img = {},

    windowSprBat = function(w, h, img_ref)
        --Keep w and h in multiples of 16!!
        local sprBat = love.graphics.newSpriteBatch(img_ref, 11, "static")
        --sprBat:clear()
        
        --co-ordinates for base
        local baseq = love.graphics.newQuad(0, 0, 64, 64, img_ref:getDimensions())
        
        --co-ordinates for corners
        local topLq = love.graphics.newQuad(64, 0, 16, 16, img_ref:getDimensions())
        local topRq = love.graphics.newQuad(112, 0, 16, 16, img_ref:getDimensions())
        local botLq = love.graphics.newQuad(64, 48, 16, 16, img_ref:getDimensions())
        local botRq = love.graphics.newQuad(112, 48, 16, 16, img_ref:getDimensions())
        
        --co-ordinates for lines
        --Horizontal Lines
        local topMq = love.graphics.newQuad(80, 0, 16, 16, img_ref:getDimensions())
        local botMq = love.graphics.newQuad(80, 48, 16, 16, img_ref:getDimensions())
        --Vertical Lines
        local midLq = love.graphics.newQuad(64, 16, 16, 16, img_ref:getDimensions())
        local midRq = love.graphics.newQuad(112, 16, 16, 16, img_ref:getDimensions())

        --Add the text box base
        local base = sprBat:add(baseq, 8, 8, 0, (w-16)/64, (h-16)/64, 0, 0)
        --Add the corners
        local topL = sprBat:add(topLq, 0, 0, 0, 1, 1, 0, 0)
        local botL = sprBat:add(botLq, 0, h-16, 0, 1, 1, 0, 0)
        local topR = sprBat:add(topRq, w-16, 0, 0, 1, 1, 0, 0)
        local botR = sprBat:add(botRq, w-16, h-16, 0, 1, 1, 0, 0)
        --Add the lines
        local topM = sprBat:add(topMq, 16, 0, 0, (w-32)/16, 1, 0, 0)
        local botM = sprBat:add(botMq, 16, h-16, 0, (w-32)/16, 1, 0, 0)
        local midL = sprBat:add(midLq, 0, 16, 0, 1, (h-32)/16, 0, 0)
        local midR = sprBat:add(midRq, w-16, 16, 0, 1, (h-32)/16, 0, 0)

        return sprBat
    end,

    --window arrays
    onScreen = {}, onScreeni = 0,

    updateAll = function(dt)
        for i = 1, #Window.onScreen, 1 do
            Window.onScreen[i]:update(dt)
        end
    end,

    drawAll = function()
        for i = 1, #Window.onScreen, 1 do
            Window.onScreen[i]:draw()
        end
    end,

    clearScreen = function()
        for i = 1, #Window.onScreen, 1 do
            Window.onScreen[i]:clear()
        end
    end
}
--set text window imgs
Window.img.default = love.graphics.newImage("Assets/Images/Windows/window_default.png")

function Window:clear()
    Window.onScreen[self.onScreeni] = nil
    self = nil
    text2 = "Window cleared!"
end

function Window:update(dt)
    
end

function Window:draw()
    --draw spr bat
    love.graphics.draw(self.windowBat, self.pos:unpack())
    --draw text (if any)
    
    local horizontal_text_offset
    local vertical_text_offset

    if self.text and self.title then --FIX

    else
        if self.text then
            --determine spacing
            horizontal_text_offset = 16 --+ 16 + 4
            vertical_text_offset = self.textHeight/4
            --print text
            love.graphics.print(self.title, self.pos.x + horizontal_text_offset, self.pos.y + 16 + (self.textHeight*(1-1)) + vertical_text_offset*1)
        end
        if self.title then -- FIX
            --determine spacing
            horizontal_text_offset = 16 --+ 16 + 4
            vertical_text_offset = self.textHeight/8
            --print title
            love.graphics.draw(self.title, self.pos.x + horizontal_text_offset, self.pos.y + 16 + (self.textHeight*(1-1)) + vertical_text_offset*1)
        end    
    end
end

Window_Dialogue = Class {
    
}

Window_Pause = Class {
    
}

Window_Menu = Class {
    
}
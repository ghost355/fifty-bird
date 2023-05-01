Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
local PIPE_SCROLL_SPEED = 55

PIPE_SPEED = 60
PIPE_GAP = 90


function Pipe:init(y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = love.graphics.getWidth(PIPE_IMAGE)
end

function Pipe:update(dt)
    self.x = self.x - PIPE_SCROLL_SPEED * dt
end

function Pipe:render()
    -- bootom pipe, half pipe gap lower than Y
    love.graphics.draw(PIPE_IMAGE, self.x, self.y + PIPE_GAP / 2)
    -- top pipe, half pipe gap upper than Y
    love.graphics.draw(PIPE_IMAGE, self.x, self.y - PIPE_GAP / 2, rotation, 1, -1)
end

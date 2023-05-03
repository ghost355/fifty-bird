Pipe = Class {}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
local PIPE_SCROLL_SPEED = 55

PIPE_SPEED = 60
-- PIPE_GAP = 10

PIPE_HEIGHT = 288
PIPE_WIDTH = 70


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.orientation = orientation
 
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
end

function Pipe:update(dt)

end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT
            or self.y), rotation, 1, self.orientation == 'top' and -1 or 1)
end

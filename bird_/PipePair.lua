PipePair = Class {}

local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lover'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipe.lower = 
    end
end

function PipePair:render()
    for k, pair in pairs(self.pipes) do
        pipe:render()
    end
end

Bird = Class {}

PLAYER_HELP_GAP = 4

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - self.width / 2
    self.y = VIRTUAL_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:collides(pipe)
    if self.x + 2 + self.width - 3 >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
        if self.y <= pipe.y - PIPE_GAP / 2 or
            self.y + self.height >= pipe.y + PIPE_GAP / 2
        then
            return true
        end
    end
    return false
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    if love.keyboard.wasPressed('space') then
        self.dy = ANTIGRAVITY
    end
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

Pause = Class { __includes = BaseState }

function Pause:init()
end

function Pause:enter(params)
    self.bird = params.bird
    self.pipePairs = params.pairs
    self.score = params.score
end

function Pause:update(dt)
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {
            bird = self.bird,
            pairs = self.pipePairs,
            score = self.score
        })
    end
end

function Pause:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end


    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    love.graphics.setFont(hugeFont)
    love.graphics.printf('PAUSE', 0, 120, VIRTUAL_WIDTH, 'center')
end

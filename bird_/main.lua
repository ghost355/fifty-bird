push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

PATH_AMPLITUDE = 30

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local zabor = love.graphics.newImage('zabor.png')
local zaborScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local ZABOR_SCROLL_SPEED = 45
local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 513
-- local SPEED_FACTOR = 1

local bird = Bird()
local pipePairs = {}

local spawnTimer = 0
-- lastY need to calculate next value of the pipe gap, to smooth flying path
local lastY = -PIPE_HEIGHT + math.random(80) + 20

local scrolling = true


GRAVITY = 20
ANTIGRAVITY = -5

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizeble = true
    })


    -- stateMachine
    gStateMachine = StateMachine {
        title = function() return TitleScreenState() end,
        play = function() return PlayState() end
    }
    gStateMachine:change('title')


    -- create empty table for hold pressed keys each frame
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- if key was pressed then it hold in the table keysPressed
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

-- check if key was pressed
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH
        zaborScroll = (zaborScroll + ZABOR_SCROLL_SPEED * dt)
            % 512


        gStateMachine:update(dt)
    end
    love.keyboard.keysPressed = {}
end

--     spawnTimer = spawnTimer + dt
--     if spawnTimer > 2 then
--         -- if Y > then your high border then Y = HighBorder (here, 80 px from top)
--         -- if Y < then your low border then Y = LowBorder (here, 80 px form bottom)
--             -- formula: math.max(top_border, math.min(value, bottom_border))

--         local y = math.max(-PIPE_HEIGHT + 10,
--             math.min(lastY + math.random(-40, 40), VIRTUAL_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT))
--         lastY = y

--         table.insert(pipePairs, PipePair(y))
--         spawnTimer = 0
--     end

--     bird:update(dt)

--     for k, pair in pairs(pipePairs) do
--         pair:update(dt)

--         for _, pipe in pairs(pair.pipes) do
--             if bird:collides(pipe) then
--                 scrolling = false
--             end
--         end

--         for k, pair in pairs(pipePairs) do
--             if pair.remove then
--                 table.remove(pipePairs, k)
--             end
--         end
--     end
-- end
-- -- reset pressed keys in the end of the frame

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(zabor, -zaborScroll, VIRTUAL_HEIGHT - 16 - 32)

    gStateMachine:render()
    -- for _, pair in pairs(pipePairs) do
    --     pair:render()
    -- end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- bird:render()

    push:finish()
end

push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

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
-- local SPEED_FACTOR = 1

local bird = Bird()
local pipes = {}

local spawnTimer = 0


GRAVITY = 20
ANTIGRAVITY = -5

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizeble = true
    })
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
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
        % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
        % VIRTUAL_WIDTH
    zaborScroll = (zaborScroll + ZABOR_SCROLL_SPEED * dt)
        % 512


    spawnTimer = spawnTimer + dt
    if spawnTimer > 3 then
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    bird:update(dt)

    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        if pipe.x < -pipe.width then
            table.remove(pipes, k)
        end
    end

    -- reset pressed keys in the end of the frame
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(zabor, -zaborScroll, VIRTUAL_HEIGHT - 16 - 32)

    bird:render()
    for _, pipe in pairs(pipes) do
        pipe:render()
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)



    push:finish()
end

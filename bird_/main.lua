push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'


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


    sounds = {
        jump = love.audio.newSource('jump.wav', 'static'),
        explosion = love.audio.newSource('explosion.wav', "static"),
        hurt = love.audio.newSource('hurt.wav', 'static'),
        score = love.audio.newSource('score.wav', "static"),

        music = love.audio.newSource('marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()


    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizeble = true
    })


    -- stateMachine
    gStateMachine = StateMachine {
        title = function() return TitleScreenState() end,
        play = function() return PlayState() end,
        score = function() return ScoreState() end,
        countdown = function() return CountdownState() end
    }
    gStateMachine:change('title')


    -- create empty table for hold pressed keys each frame
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
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

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.mouse.justPressed(button)
    return love.mouse.buttonsPressed[button]
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
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(zabor, -zaborScroll, VIRTUAL_HEIGHT - 16 - 32)

    gStateMachine:render()


    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)



    push:finish()
end

-- add the push library
push = require 'push'
--add the class library
Class = require 'class'
--add the Classes created
require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'Medal'
--add the different statese the game can enter
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/PauseState'

-- define constants
WD_WIDTH = 1280
WD_HEIGHT = 720
VT_WIDTH = 512
VT_HEIGHT = 288
--define background speed
local BG_SPEED = 30 
--define ground speed, faster for the parallax effect
local G_SPEED = 60
--loop point at  413 pixels
local BG_LOOP = 413
-- create background image
local background = love.graphics.newImage('background.png')
--initialize scrolls to 0
local backgroundScroll = 0
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0
--initialize bird and pipes
local bird = Bird()

local pipePairs = {}
--initialize timer to generate pipes
local timer = 0

local lastY = -PIPE_HGT + math.random(80) + 20
-- boolean to set scroll
local scrolling = true


function love.load()
    -- want nearest neighbor filter instead of bilinear
    love.graphics.setDefaultFilter('nearest','nearest')
    --set random seed to time for best results 
    math.randomseed(os.time())
    --window title
    love.window.setTitle('Flappy Bird')
    -- load in the multiple fonts the game will use
    smallFont = love.graphics.newFont('font.ttf',8)
    mediumeFont = love.graphics.newFont('flappy.ttf',16)
    flappyFont = love.graphics.newFont('flappy.ttf',28)
    hugeFont = love.graphics.newFont('flappy.ttf',56)
    love.graphics.setFont(flappyFont)
    --load in sounds the game will use
    sounds = {
        ['jump'] = love.audio.newSource('Jump.wav','static'),
        ['explosion'] = love.audio.newSource('Explosion.wav','static'),
        ['hurt'] = love.audio.newSource('hurt.wav','static'),
        ['score'] = love.audio.newSource('score.wav','static'),
        ['music'] = love.audio.newSource('mario.mp3','static')
    }
    -- set background music to loop and play infinitely
    sounds['music']:setLooping(true)
    sounds['music']:play()
    -- create screen 
    push:setupScreen(VT_WIDTH,VT_HEIGHT,WD_WIDTH,WD_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })
    -- create gamestate table 
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end
    }
    -- begin in the title state
    gStateMachine:change('title')
    -- instantiate empty table of keys pressed
    love.keyboard.keysPressed = {}
    -- initialize mouse pressed table
    love.mouse.buttonsPressed = {}
end
-- make it possible to resize the window to a larger or smaller size
function love.resize(width,height)
    --defers width and height to be decided upon resizing
    push:resize(width,height)
end
--function to handle mouse input
function love.mousepressed(x,y,button)
    love.mouse.buttonsPressed[button] = true
end
-- function to exit game
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then 
        love.event.quit()
    end
end
-- function to determine was mouse has been 'pressed'
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end
-- key function to determine whether a key has been pressed or not
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- set background and ground scroll
    if scrolling then 
        backgroundScroll = (backgroundScroll + BG_SPEED * dt)
            % BG_LOOP
        groundScroll = (groundScroll + G_SPEED * dt)
            % VT_WIDTH

        --update state machine which updates everything else
        gStateMachine:update(dt)
        -- reset the keysPressed table to be empty
        --if not done then once a key is pressed it will not be recorded again (very bad)
        love.keyboard.keysPressed = {}
        --reset mouse input table to empty
        love.mouse.buttonsPressed = {}
    end
end
-- render the game
function love.draw()
    --render the virtual res
    push:start() 

    love.graphics.draw(background,-backgroundScroll,0)
    -- must render game state between background & ground or the pipes will not look correct 
    gStateMachine:render()

    love.graphics.draw(ground,-groundScroll,VT_HEIGHT-16)
    -- end rendering the virtual res
    push:finish()
end
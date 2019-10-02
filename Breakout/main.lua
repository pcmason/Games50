
require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')
    --set random seed to time
    math.randomseed(os.time())

    love.window.setTitle('Breakout')
    --create table of fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf',8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf',16),
        ['large'] = love.graphics.newFont('fonts/font.ttf',32)
    }
    love.graphics.setFont(gFonts['small'])
    --table of textures used
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrow'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    push:setupScreen(VT_WIDTH,VT_HEIGHT,WD_WIDTH,WD_HEIGHT, {
        vsync = true ,
        fullscreen = false,
        resizable = true
    })
    --table of sounds used in game
    gSounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav','static'),
        ['select'] = love.audio.newSource('sounds/select.wav','static'),
        ['no_select'] = love.audio.newSource('sounds/no_select.wav','static'),
        ['brick_hit_one'] = love.audio.newSource('sounds/brick_hit_one.wav','static'),
        ['brick_hit_two'] = love.audio.newSource('sounds/brick_hit_two.wav','static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav','static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav','static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav','static'),
        ['high_score'] = love.audio.newSource('sounds/high_score.wav','static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav','static'),
        ['music'] = love.audio.newSource('sounds/music.wav','static'),
        ['paddle_grow']=love.audio.newSource('sounds/paddle_grow.wav','static'),
        ['paddle_shrink']=love.audio.newSource('sounds/paddle_shrink.wav','static')
    }
    --textures generated from functions found in Util.lua
    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        --['small_paddles'] = GenerateQuadsSmallPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'],10,9),
        ['arrows'] = GenerateQuads(gTextures['arrow'],24,24),
        -- creating a powerup to make game more interesting 
        ['powerup'] = GenerateQuadsPowerups(gTextures['main']),
    }
    --functions to create state elaborated on in states file
    gStateMachine = StateMachine{
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game_over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high_score'] = function() return HighScoreState() end,
        ['high_score_enter'] = function() return EnterHighScoreState() end,
        ['paddle_select'] = function() return PaddleSelectState() end
    }
    --create a highscore table
    highScores = {}
    gStateMachine:change('start',{
        --begin by loading in highscores so they can be viewed instantly
        highScores = loadHighScores()
    })
    --loop music so game is more interesting
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:apply('start')

    local bgWidth = gTextures['background']:getWidth()
    local bgHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        0,0,
        0,
        VT_WIDTH / (bgWidth - 1),VT_HEIGHT / (bgHeight-1))

    gStateMachine:render()

    displayFPS()

    push:apply('end')
end
--display the fps in the top-left corner
function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0,255,0,255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS(),5,5))
end
--show the health in the top-right corner
function renderHealth(health)
    local healthX = VT_WIDTH - 100
    
    for i =1, health do 
        love.graphics.draw(gTextures['hearts'],gFrames['hearts'][1],healthX,4)
        healthX = healthX + 11
    end

    for i = 1,3-health do 
        love.graphics.draw(gTextures['hearts'],gFrames['hearts'][2],healthX,4)
        healthX = healthX + 11
    end

end
--function to show score during game
function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ',VT_WIDTH-60,5)
    love.graphics.printf(tostring(score),VT_WIDTH-50,5,40,'right')
end
--function used when entering high score state
function loadHighScores()
    --create a file to store all of the highscores
    love.filesystem.setIdentity("breakout")
    if not love.filesystem.exists("breakout.lst") then 
        local scores = ''
        -- if no file on system then fill highscores automatically
        for i = 10, 1,-1 do 
            scores = scores .. 'PCM\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        --now create the file so it can be edited for future highscores
        love.filesystem.write("breakout.lst",scores)
    end
        local name = true
        local currentName = nil
        local counter = 1
        
        local scores = {}
        for i =1,10 do 
            scores[i] = {
                name = nil,
                score = nil
            }
        end
        for line in love.filesystem.lines("breakout.lst") do 
            if name then 
                scores[counter].name = string.sub(line,1,3)
            else
                scores[counter].score = tonumber(line)
                counter = counter + 1
            end
            name = not name
        end
    return scores 
end



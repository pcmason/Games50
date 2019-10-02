PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores

end
--initialize with the blue paddle first
function PaddleSelectState:init()
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    --scroll through paddle options with no rollovers
    if love.keyboard.wasPressed('left') then 
        if self.currentPaddle == 1 then 
            gSounds['no_select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle -1 
        end
    elseif love.keyboard.wasPressed('right') then 
        if self.currentPaddle == 4 then
            gSounds['no_select']:play()
        else
            gSounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end
    --change to serve state to initialize the game
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        gSounds['confirm']:play()
        --need to load everything for the game to work here
        gStateMachine:change('serve',{
            paddle = Paddle(self.currentPaddle,2,64),
            bricks= LevelMaker.createMap(1),
            powerup = Powerup(),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 1,
            skin = self.currentPaddle,
            size = 2,
            width = 64
        })
    end
    --exit game
    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
end
function PaddleSelectState:render()
    --text rendering
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your Paddle with Left and Right!",0,VT_HEIGHT / 4,VT_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to continue!',0,VT_HEIGHT/3,VT_WIDTH,'center')
    if self.currentPaddle == 1 then 
        love.graphics.setColor(0,0,0,128)
    end
    love.graphics.draw(gTextures['arrow'],gFrames['arrows'][1],VT_WIDTH/4 -24,VT_HEIGHT - VT_HEIGHT/3)
    love.graphics.setColor(255,255,255,255)

    if self.currentPaddle == 4 then 
        love.graphics.setColor(0,0,0,128)
    end
    love.graphics.draw(gTextures['arrow'],gFrames['arrows'][2],VT_WIDTH - VT_WIDTH / 4,VT_HEIGHT - VT_HEIGHT / 3)
    love.graphics.setColor(255,255,255,255)

    love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)],
        VT_WIDTH / 2 - 32, VT_HEIGHT - VT_HEIGHT / 3)
end
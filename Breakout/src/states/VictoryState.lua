VictoryState = Class{__includes = BaseState}
--pass in parameters from teh play state
function VictoryState:enter(params)
    self.level = params.level
    self.score = params.score
    self.paddle = params.paddle
    self.health = params.health
    self.ball = params.ball
    self.highScores = params.highScores
    self.paddleWidth = params.paddleWidth
    self.size = params.size
    self.skin = params.skin
    self.width = params.width
    self.smallpaddle = params.smallpaddle
end

function VictoryState:update(dt)
    --can move the paddle during victory state
    self.paddle:update(dt)
    --place the ball on top of the paddle
    self.ball.x = self.paddle.x +(self.paddle.width / 2) - 4
    self.ball.y = self.paddle.y -8
    --add one to the level to increase difficulty, pass everythin else as the same
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        gStateMachine:change('serve',{
            level = self.level + 1,
            score = self.score,
            paddle = self.paddle,
            health = self.health,
            ball = self.ball,
            bricks = LevelMaker.createMap(self.level+1),
            highScores = self.highScores,
            powerup = Powerup(),
            width = self.width,
            size = self.size,
            skin = self.skin
        })
    end
end

function VictoryState:render()
    --render ball, paddle, score and health
    self.paddle:render()
    self.ball:render()
    renderHealth(self.health)
    renderScore(self.score)
    --render text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Level " .. tostring(self.level) .. " Completed!",0,VT_HEIGHT/4,VT_WIDTH,'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press Enter to Serve",0,VT_HEIGHT/4 + 40,VT_WIDTH,'center')
end

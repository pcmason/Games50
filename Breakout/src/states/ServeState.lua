ServeState = Class{__includes = BaseState}
--pass in all variables from PaddleSelectState/PlayState
function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = Ball()
    --ball color randomized every serve state entry
    self.ball.skin = math.random(7)
    self.level = params.level
    self.highScores = params.highScores
    self.powerup = params.powerup
    self.width = params.width
    self.size = params.size
    self.skin = params.skin
    self.smallpaddle = params.smallpaddle
end

function ServeState:update(dt)
    --allow paddle to move during serve state
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width / 2)-4
    self.ball.y = self.paddle.y - 8
    --once they serve seamlessly move into the play state
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        gStateMachine:change('play',{
            paddle = self.paddle,
            bricks = self.bricks,
            health = self.health,
            score = self.score,
            ball = self.ball,
            level = self.level,
            highScores = self.highScores,
            powerup = self.powerup,
            skin = self.skin,
            width = self.width,
            size = self.size,
        })
    end
    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
end

function ServeState:render()
    --render ball and paddle for the servestate
    self.paddle:render()
    self.ball:render()
    --render the bricks
    for k,brick in pairs(self.bricks) do 
        brick:render()
    end
    --also render the powerup
    self.powerup:render()
    love.graphics.setFont(gFonts['medium'])
    --render font
    love.graphics.printf('Press Enter to Serve',0,VT_HEIGHT/2 - 16,VT_WIDTH,'center')

end
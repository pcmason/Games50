PlayState = Class{__includes = BaseState}
--pass in the parameters from the servestate
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.powerup = params.powerup
    self.ball = params.ball
    self.level = params.level
    self.ball.dx = math.random(-200,200)
    self.ball.dy = math.random(-50,-60)
    self.highScores = params.highScores
    self.skin = params.skin
    self.ball2 = Ball(math.random(7))
    --set both balls above the screen so player cannot see them
    self.ball2.x = 100
    self.ball2.y = 1000
    self.ball3 = Ball(math.random(7))
    self.ball3.x = 100
    self.ball3.y = 1000
    self.size = params.size
    self.width = params.width
end

function PlayState:update(dt)
    --pause the game when spacebar is pressed
    if self.paused then 
        if love.keyboard.wasPressed('space') then 
            self.paused = false
            gSounds['pause']:play()
        else
            return 
        end
    -- unpause when spacebar is pressed again
    elseif love.keyboard.wasPressed('space') then 
            self.paused = true
            gSounds['pause']:play()
            return
    end
    --have paddle move
    self.paddle:update(dt)
    --have ball move
    self.ball:update(dt)
    --check for collisions with ball and paddle
    if self.ball:collide(self.paddle)then 
        --sub 8 to make the ball not look like it is going through the paddle
        self.ball.y = self.ball.y - 8
        --reverse balls y direction
        self.ball.dy = -self.ball.dy
        --add speed to ball if it is hit by the edges of the paddle
        if self.ball.x < self.paddle.x + (self.paddle.width/2) and self.paddle.dx < 0 then 
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width/2 - self.ball.x))
        elseif self.ball.x > self.paddle.x + (self.paddle.width /2) and self.paddle.dx > 0 then 
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end
        gSounds['paddle_hit']:play()
    end
    --same for ball 2
    if self.ball2:collide(self.paddle)then 
        self.ball2.y = self.ball2.y - 8
        self.ball2.dy = -self.ball2.dy
        if self.ball2.x < self.paddle.x + (self.paddle.width/2) and self.paddle.dx < 0 then 
            self.ball2.dx = -50 + -(8 * (self.paddle.x + self.paddle.width/2 - self.ball2.x))
        elseif self.ball2.x > self.paddle.x + (self.paddle.width /2) and self.paddle.dx > 0 then 
            self.ball2.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball2.x))
        end
        gSounds['paddle_hit']:play()
    end
    --same for ball 3
    if self.ball3:collide(self.paddle)then 
        self.ball3.y = self.ball3.y - 8
        self.ball3.dy = -self.ball3.dy
    
        if self.ball3.x < self.paddle.x + (self.paddle.width/2) and self.paddle.dx < 0 then 
            self.ball3.dx = -50 + -(8 * (self.paddle.x + self.paddle.width/2 - self.ball3.x))
        elseif self.ball3.x > self.paddle.x + (self.paddle.width /2) and self.paddle.dx > 0 then 
            self.ball3.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball3.x))
        end

        gSounds['paddle_hit']:play()
    end
    --losing a life when the powerup is being used
    if self.powerup.inplay == false and self.ball2.y ~= 1000 then
        --check if balls have gone 'below' the screen
        if self.ball.y >= VT_HEIGHT and self.ball2.y >= VT_HEIGHT and self.ball3.y >= VT_HEIGHT then 
            self.health = self.health - 1
        
        gSounds['hurt']:play()
            --if there are no lives then go to gameovers state
            if self.health == 0 then 
                gStateMachine:change('game_over',{
                    score = self.score,
                    highScores = self.highScores
                })
            --else go back to the serve state
            else
                gStateMachine:change('serve',{
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores,
                    powerup = self.powerup,
                    size = self.size,
                    width = self.width,
                    skin = self.skin,
                    smallpaddle = self.smallpaddle
                })
            end
        end
    --losing a life if the powerup is not being used
    else
        if self.ball.y >= VT_HEIGHT then 
            --check if only ball has gone below the screen   
            self.health = self.health - 1

            
            gSounds['hurt']:play()
            --if no lives left game over
            if self.health == 0 then 
                gStateMachine:change('game_over',{
                    score = self.score,
                    highScores = self.highScores
                })
            --else keep playing
            else
                gStateMachine:change('serve',{
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score,
                    level = self.level,
                    highScores = self.highScores,
                    powerup = self.powerup,
                    size = self.size,
                    width = self.width,
                    skin = self.skin,
                    smallpaddle = self.smallpaddle
                })
            end
        end
    end
    --used for the psystem stuff
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end
    --quit the game
    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
    --make paddle smaller if score is greater than 1000 to add difficultly
    if self.score > 1000 then 
        self.paddle.small = true
    end
    --make paddle larger if on last life to decrease difficulty
    if self.health < 2 then 
        self.paddle.larger = true
    end
    --add more balls if ball powerup is hit 
    if self.powerup.inplay == true and self.ball:collide(self.powerup) then 
        self.powerup:hit()
        --change direction based on where the ball hit powerup
        if self.ball.x + 2 < self.powerup.x and self.ball.dx > 0 then 
            self.ball.dx = -self.ball.dx
            self.ball.x = self.powerup.x - 8
        elseif self.ball.x + 6 > self.powerup.x + self.powerup.width and self.ball.dx <0 then 
            self.ball.dx = -self.ball.dx
            self.ball.x = self.powerup.x + 32
        elseif self.ball.y <self.powerup.y then 
            self.ball.dy = -self.ball.dy
            self.ball.y = self.powerup.y -8
        else
            self.ball.dy = -self.ball.dy
            self.ball.y = self.powerup.y + 16
        end
        --add slight amount of speed to ball for hitting powerup
        self.ball.dy = self.ball.dy *1.03
        --move the balls to where the powerup was
        self.ball2.x = 100
        self.ball2.y = 100
        --give both balls randomized speeds
        self.ball2.dx = math.random(-200,200)
        self.ball2.dy = math.random(-50,-60)
        self.ball3.x = 100
        self.ball3.y = 100
        self.ball3.dx = math.random(-200,200)
        self.ball3.dy = math.random(-50,-60)
    end
    --update ball2 and 3 if in play
    self.ball2:update(dt) 
    self.ball3:update(dt) 
    --check for ball colliding with brick
    for k, brick in pairs(self.bricks) do 
        if brick.inPlay and self.ball:collide(brick)then 
            brick:hit()
            --add to score appropriately given the bricks tier && color
            self.score = self.score + (brick.tier * 200 + brick.color * 25)
            --check if there are any bricks left, if none go to next level
            if self:checkVictory() then 
                gSounds['victory']:play()
                gStateMachine:change('victory',{
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores,
                    ball2 = self.ball2,
                    width = self.width,
                    size = self.size
                })
            end
            --have ball move based on where it has hit the brick
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then 
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx <0 then 
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            elseif self.ball.y < brick.y then 
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y -8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            --add a slight amount of speed to the ball to increase excitement
            self.ball.dy = self.ball.dy *1.03
            break
        --do same for ball 2
        elseif brick.inPlay and self.ball2:collide(brick)then 
            brick:hit()
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            if self:checkVictory() then 
                gSounds['victory']:play()
                gStateMachine:change('victory',{
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores
                })
            end

            if self.ball2.x + 2 < brick.x and self.ball2.dx > 0 then 
                self.ball2.dx = -self.ball2.dx
                self.ball2.x = brick.x - 8
            elseif self.ball2.x + 6 > brick.x + brick.width and self.ball2.dx <0 then 
                self.ball2.dx = -self.ball2.dx
                self.ball2.x = brick.x + 32
            elseif self.ball2.y < brick.y then 
                self.ball2.dy = -self.ball2.dy
                self.ball2.y = brick.y -8
            else
                self.ball2.dy = -self.ball2.dy
                self.ball2.y = brick.y + 16
            end
            self.ball2.dy = self.ball2.dy *1.03

            break
        --do same for ball 3
        elseif brick.inPlay and self.ball3:collide(brick)then 
            brick:hit()
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            if self:checkVictory() then 
                gSounds['victory']:play()
                gStateMachine:change('victory',{
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball,
                    highScores = self.highScores
                })
            end

            if self.ball3.x + 2 < brick.x and self.ball3.dx > 0 then 
                self.ball3.dx = -self.ball3.dx
                self.ball3.x = brick.x - 8
            elseif self.ball3.x + 6 > brick.x + brick.width and self.ball3.dx <0 then 
                self.ball3.dx = -self.ball3.dx
                self.ball3.x = brick.x + 32
            elseif self.ball3.y < brick.y then 
                self.ball3.dy = -self.ball3.dy
                self.ball3.y = brick.y -8
            else
                self.ball3.dy = -self.ball3.dy
                self.ball3.y = brick.y + 16
            end
            self.ball3.dy = self.ball3.dy *1.03
            break
        end
    end
end

function PlayState:render()
    --render bricks
    for k,brick in pairs(self.bricks) do 
        brick:render()
    end
    --render psystem
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end
    --render powerup 
    self.powerup:render()
    --render paddle
    self.paddle:render()
    --render balls
    self.ball:render()
    self.ball2:render()
    self.ball3:render()
    --render both the score and health
    renderScore(self.score)
    renderHealth(self.health)
    --render graphics for when game is paused
    if self.paused == true then 
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Paused',0,VT_HEIGHT/2 - 16,VT_WIDTH,'center')
    end
end
--check if there are any bricks still in play, if none level is over
function PlayState:checkVictory()
    for k,brick in pairs(self.bricks) do 
        if brick.inPlay then 
            return false
        end
    end
    return true
end





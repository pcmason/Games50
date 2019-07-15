--adding the push library to make a virtual resolution window
push = require 'push'
--add library class to create classes
Class = require 'class'
--add ball and padddle
require 'Ball'
require 'Paddle'

--set constant variables
WD_WIDTH = 1280
WD_HEIGHT = 720
VT_WIDTH = 432
VT_HEIGHT = 243
--set paddle speed 
PADDLE_SP = 275

--load game when it starts up
function love.load()
    --set scaling to nearest-neighbor instead of bilinear
    love.graphics.setDefaultFilter('nearest','nearest')

    --set application title
    love.window.setTitle('Pong')

    --create seed using time
    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf',8)
    love.graphics.setFont(smallFont)
    --create font for score
    scoreFont = love.graphics.newFont('font.ttf',32)

    --initialize virtual resolution
    push:setupScreen(VT_WIDTH,VT_HEIGHT,WD_WIDTH,WD_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
    --initialize sounds
    sounds = {
        ['paddle_hit']= love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static'),
        ['ball_hit'] = love.audio.newSource('sounds/ball_hit.wav','static')
    }
    --initialize player scores
    p_one_sc = 0
    p_two_sc = 0
    --initialize paddles (players)
    playerOne = Paddle(10,30,5,20)
    playerTwo = Paddle(VT_WIDTH-10,VT_HEIGHT-30,5,20)
    --arguments to be given to ball one when initialized
    ballOneX = VT_WIDTH /2 -2 
    ballOneY = VT_HEIGHT /2 -2
    --may add more balls later

    --initialize ball
    ball = Ball(ballOneX, ballOneY,4,4)

    --initialize serving player to 1
    servingPlayer = 1
    winningPlayer = 0
    --gameState begins in the start state
    gameState = 'start'
end
--functiont to update movement of ball and paddles
function love.update(dt)
    --create serve gamestate
    if gameState == 'serve' then
        ball.dy = math.random(-50,50)
        -- set serving ITE statement based on who last scored
        if servingPlayer == 1 then 
            ball.dx = math.random(300,350)
        else
            ball.dx = -math.random(300,350)
        end

    elseif gameState == 'play' then
        --detect paddle collision for both players
        if ball:collide(playerOne) then
            --speed up ball slightly each hit
            ball.dx = -ball.dx * 1.03
            ball.x = playerOne.x + 5
            if ball.dy < 0 then 
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collide(playerTwo) then
            ball.dx = -ball.dx * 1.03
            ball.x = playerTwo.x - 4
            if ball.dy < 0 then 
                ball.dy = -math.random(10,150)
            else
                ball.dy = math.random(10,150)
            end
            sounds['paddle_hit']:play()
        end
        
        --detect screen collision
        --bottom screen
        if ball.y <= 0 then 
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        -- top screen
        if ball.y >= VT_HEIGHT -4 then
            ball.y = VT_HEIGHT -4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
    end
    -- how to increment score and reset ball position    
    if ball.x < 0 then 
        -- set serving player
        servingPlayer = 1
        --increment score
        p_two_sc = p_two_sc + 1
        sounds['score']:play()
        -- set endgame scenario when one player scores 10
        if p_two_sc == 10 then 
            ball:reset(ballOneX,ballOneY)
            -- change the gamestate and set winning player if scored 10
            gameState = 'done'
            winningPlayer = 2
        else
            -- else go into next serve
            gameState = 'serve'
            ball:reset(ballOneX,ballOneY)
        end
    end
    -- same for when other player scores
    if ball.x > VT_WIDTH then 
        servingPlayer = 2
        p_one_sc = p_one_sc +1
        sounds['score']:play()
        if p_one_sc == 10 then 
            ball:reset(ballOneX,ballOneY)
            gameState = 'done'
            winningPlayer = 1
        else 
            gameState = 'serve'
            ball:reset(ballOneX,ballOneY)
        end
    end
    
    --player 1 movement
    if love.keyboard.isDown('w') then 
        --makes sure paddles does not cross game 'boundary' repeated throughout
        playerOne.dy = -PADDLE_SP
    elseif love.keyboard.isDown('s') then
       playerOne.dy = PADDLE_SP
    else
        playerOne.dy = 0
    end
    --player 2 movement
    if love.keyboard.isDown('up') then
        playerTwo.dy = -PADDLE_SP
    elseif love.keyboard.isDown('down') then
        playerTwo.dy = PADDLE_SP
    else
        playerTwo.dy = 0
    end
    --ball moves during the 'play' state
    if gameState == 'play' then
        ball:update(dt)
    end

    playerOne:update(dt)
    playerTwo:update(dt)
end


--function to exit game
function love.keypressed(key)
    -- quits application when escape is pressed
    if key == 'escape' then
        love.event.quit()
    -- changes the game state when enter is pressed
    elseif key == 'enter' or key =='return' then
        if gameState == 'start' then 
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then 
            gameState = 'serve'
            ball:reset(ballOneX,ballOneY)
            -- reset score if another game is requested
            p_one_sc = 0
            p_two_sc = 0
            --giving losing player first serve
            if winningPlayer == 1 then 
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

function love.draw()
    --start rendering virtual res
    push:start()

    --set font
    love.graphics.setFont(smallFont)
    -- messages for different game states
    if gameState == 'start' then
        love.graphics.printf('Hello Pong',0,20,VT_WIDTH,'center')
    elseif gameState == 'serve' then
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. ' hit enter to serve the ball', 0,20,VT_WIDTH,'center')
    elseif gameState == 'play' then 
        --do nothing
    elseif gameState == 'done' then 
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',0,10,VT_WIDTH,'center')
        love.graphics.printf('Press enter to play again.', 0,20,VT_WIDTH,'center')
    end


    --print out players scores
    displayScores()
    --render two paddles and ball
    playerOne:render()
    playerTwo:render()
    ball:render()
    --print out Frames Per Second
    displayFPS()

    --end rendering virtual res
    push:finish()
end
--create displayScores function 
function displayScores()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(p_one_sc),VT_WIDTH/2 - 50, VT_HEIGHT/3)
    love.graphics.print(tostring(p_two_sc),VT_WIDTH/2 +30, VT_HEIGHT/3)
end
--renders FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0,255,0,255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),10,10)
end

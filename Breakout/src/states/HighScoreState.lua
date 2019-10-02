HighScoreState = Class{__includes = BaseState}
--pass in the high scores
function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then 
        gSounds['wall_hit']:play()
        --change back to start screen and pass in highscores
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render() 
    --print out highscores
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores',0,20,VT_WIDTH,'center')

    love.graphics.setFont(gFonts['medium'])
    --only 10 high scores make the cut
    for i =1,10 do 
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'

        love.graphics.printf(tostring(i) .. '.',VT_WIDTH / 4, 60 + i *13,50,'left')

        love.graphics.printf(name, VT_WIDTH/4 + 38, 60 + i * 13,50,'right')

        love.graphics.printf(tostring(score),VT_WIDTH/2,60 + i * 13, 100,'right')

    end

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Escape to Return to Main Menu!',0,VT_HEIGHT-18,VT_WIDTH,'center')
end




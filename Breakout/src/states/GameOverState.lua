GameOverState = Class{__includes = BaseState}
--pass score to see if score beat a high scores
function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then 
        local highScore = false
        local scoreIndex = 11
        --check if score has beaten any of the highscores
        for i = 10, 1,-1 do 
            local score = self.highScores[i].score or 0 
            if self.score > score then 
                highScoreIndex = i
                highScore = true
            end
        end
        --if it has then go to the highscore state
        if highScore then 
            gSounds['high_score']:play()
            gStateMachine:change('high_score_enter',{
                highScores = self.highScores,
                score = self.score,
                scoreIndex = highScoreIndex
            })
        else
        --if not go to start screen
            gStateMachine:change('start',{
                highScores = self.highScores
            })
        end
    end
    if love.keyboard.wasPressed('escape') then 
        love.event.quit()
    end
end

function GameOverState:render()
    --render text
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('GAME OVER',0,VT_HEIGHT /3,VT_WIDTH,'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Final Score: ' .. tostring(self.score),0,VT_HEIGHT/2,VT_WIDTH,'center')
    love.graphics.printf('Press Enter!',0,VT_HEIGHT-VT_HEIGHT/4,VT_WIDTH,'center')
end

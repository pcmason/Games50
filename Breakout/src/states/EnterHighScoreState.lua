EnterHighScoreState = Class{__includes = BaseState}
--three characters all set to A
local chars = {
    [1] = 65,
    [2] = 65,
    [3] = 65
}
--have first character highlighted
local highlightedChar = 1
 
function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.score = params.score
    self.scoreIndex = params.scoreIndex
end

function EnterHighScoreState:update(dt)
    --enter name if enter has been pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local name = string.char(chars[1]) .. string.char(chars[2]) .. string.char(chars[3])
        for i =10,self.scoreIndex -1 do 
            self.highScores[i+ 1] {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end

        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score
        local scoreStr = ''
        for i =1,10 do 
            scoreStr = scoreStr .. self.highScores[i].name .. '\n'
            scoreStr = scoreStr .. tostring(self.highScores[i].score) .. '\n'
        end
        --load the new highscore file and go into the highscore state
        love.filesystem.write('breakout.lst',scoreStr)
        gStateMachine:change('high_score',{
            highScores = self.highScores
        })
    end
    --change which character is highlighted
    if love.keyboard.wasPressed('right') and highlightedChar < 3 then 
        highlightedChar = highlightedChar + 1
        gSounds['wall_hit']:play()
    elseif love.keyboard.wasPressed('left') and highlightedChar >1 then 
        highlightedChar = highlightedChar - 1
        gSounds['wall_hit']:play()
    end
    --change the letter with rollover included
    if love.keyboard.wasPressed('up') then 
        chars[highlightedChar] = chars[highlightedChar] + 1
        if chars[highlightedChar] > 90 then 
            chars[highlightedChar] = 65
        end

    elseif love.keyboard.wasPressed('down') then 
        chars[highlightedChar] = chars[highlightedChar] - 1
        if chars[highlightedChar] < 65 then 
            chars[highlightedChar] = 90
        end
    end
end

function EnterHighScoreState:render()
    --render text
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score),0,30,VT_WIDTH,'center')

    love.graphics.setFont(gFonts['large'])

    if highlightedChar == 1 then 
        love.graphics.setColor(0,0,0,255)
    end

    love.graphics.print(string.char(chars[1]),VT_WIDTH/2 -28,VT_HEIGHT / 2)
    love.graphics.setColor(255,255,255,255)

    if highlightedChar == 2 then 
        love.graphics.setColor(0,0,0,255)
    end

    love.graphics.print(string.char(chars[2]),VT_WIDTH/2 -6,VT_HEIGHT / 2)
    love.graphics.setColor(255,255,255,255)

    if highlightedChar == 3 then 
        love.graphics.setColor(0,0,0,255)
    end

    love.graphics.print(string.char(chars[3]),VT_WIDTH/2 + 20,VT_HEIGHT / 2)
    love.graphics.setColor(255,255,255,255)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to Confirm!',0,VT_HEIGHT-18,VT_WIDTH,'center')

end



Medal = Class {}
-- create a medal class that can have one of three different options
--gold, silver and bronze
function Medal:init(img)
    self.image = love.graphics.newImage(img)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VT_WIDTH / 2 -(self.width/2)
    self.y = VT_HEIGHT /2 -(self.height/2)
end

function Medal:render()
    love.graphics.draw(self.image,self.x,self.y - 20)
end


    
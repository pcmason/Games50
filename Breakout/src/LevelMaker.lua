LevelMaker = Class{}
--constants to create varied levels
--pyramid says how many pyramids will generate
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3
--states if row will have solids, alternates (striped), skip (one every other place), or no bricks
SOLID = 1
ALTERNATE =2 
SKIP = 3
NONE = 4
ispowerup = false

function LevelMaker.createMap(level)
    local bricks = {}
    --can be anywhere from 1-5 rows
    rows = math.random(1,5)
    --can be anywhere from 7-13 columns
    columns = math.random(7,13)
    columns = columns % 2 ==0 and (columns + 1) or columns
    -- created to make game harder as levels progress
    local high_tier = math.min(3,math.floor(level/5))
    local high_color = math.min(5,level % 5 + 3)
    if math.random(3) == 2 then 
        ispowerup = true
    end

    for y=1,rows do 
        -- decides how bricks are lain out
        local skip_pattern = math.random(1,2) ==1 and true or false
        local alt_pattern = math.random(1,2) == 1 and true or false
        local alt_color_one = math.random(1,high_color)
        local alt_color_two = math.random(1,high_color)
        local alt_tier_one = math.random(0,high_tier)
        local alt_tier_two = math.random(0,high_tier)

        local skip_flag = math.random(2) == 1 and true or false
        local alt_flag = math.random(2) == 1 and true or false

        local solid_color = math.random(1,high_color)
        local solid_tier = math.random(0,high_tier)
        for x = 1,columns do 
            if skip_pattern and skip_flag then 
                skip_flag = not skip_flag

                goto continue
            else 
                skip_flag = not skip_flag
            end
            -- fill table b with Bricks
            b = Brick(
                (x-1)
                *32
                +8
                + (13-columns) * 16,
                y*16
            )

            if alt_pattern and alt_flag then
                b.color = alt_color_one
                b.tier = alt_tier_one
                alt_flag = not alt_flag
            else 
                b.color = alt_color_two
                b.tier = alt_tier_two
                alt_flag = not alt_flag
            end

            if not alt_pattern then 
                b.color = solid_color
                b.tier = solid_tier
            end


            table.insert(bricks,b)
            ::continue::
        end
    end
    -- if no bricks are generated then go again
    if #bricks == 0 then 
        return self.createMap(level)
    else
        return bricks
    end
end






--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

--[[
    Level has been added to the function because once 
    flagCaugth becomes true the gStateMachine must change from 
    'play' state to 'next' state and back to begin the next level. 
]]
function LevelMaker.generate(width, height, level)
    local tiles = {}
    local entities = {}
    local objects = {}
    local level = level
    --created so lock wont spawn flag unless player has key
    local playerHasKey = false
    --created so that once flag is caught then player proceeds to next level. 
    flagCaught = nil

    LEVEL_LENGTH = 20
    --both made to gurantee generation of one key and one block no more
    local isKey = false
    local isLock = false
    --this sets the key color, which then sets the lock color later
    local keyColor = math.random(4)

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(LEVEL_LENGTH)
    local topperset = math.random(LEVEL_LENGTH)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end


        -- chance to just be emptiness
        --make sure that the first tile, the one the player spawns over, is ground
        --also make sure that the last tile, where the pole will be, is ground
        if math.random(7) == 1 and x ~= 1 and x~= width then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND


            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            --gurantees that a pillar does not appear on the last tile, where pole will be
            if math.random(8) == 1 and x ~= width then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                --gurantee that jump-block gives either a key OR a gem
                                elseif math.random(3) == 1 and not isKey then 
                                    --gurantee no more keys
                                    isKey = true
                                    local key = GameObject {
                                        texture = 'keys',
                                        x = (x-1) * TILE_SIZE,
                                        y = (blockHeight-1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = keyColor,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        onConsume = function(player,object)
                                            gSounds['pickup']:play()
                                            playerHasKey = true
                                        end
                                    }
                                    Timer.tween(0.1, {
                                     [key] = {y = (blockHeight-2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects,key)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
            --add a keylock block
            if math.random(10) == 1 and not isLock then
                --gurantee no other lock can be generated
                isLock = true
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        --gurantee the keyColor and lock color is the same
                        frame = keyColor + 4,
                        collidable = true,
                        hit = false,
                        solid = true,
                        consumable = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- check is lock has been hit
    

                            -- if player has key then they can unlock the lock
                            if playerHasKey then 
                                gSounds['powerup-reveal']:play()
                                --pole is not generated with a flag, may fix later
                                local flag = GameObject{
                                    texture = 'flag',
                                    x = (width-1) * TILE_SIZE,
                                    y = 3 * TILE_SIZE,
                                    width = 16,
                                    height = 16,
                                    hit = false,
                                    frame = math.random(5),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    onConsume = function(player, obj)
                                        gSounds['pickup']:play()
                                        PlayState.levelOver = true
                                        flagCaught = true
                                        gStateMachine:change('next',{
                                            level = level
                                        })
                                    end

                                    
                                    }
                                    table.insert(objects,flag)
                            end

                                

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end
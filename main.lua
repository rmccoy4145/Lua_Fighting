io.stdout:setvbuf("no")
local class = require 'fighting_classes'
local bump = require 'bump'

function love.load()

--create collision world
world = bump.newWorld(64)

--player objects, selecting characters
player1 = Fighter_a:new()
player1.name = 'player1'
player1.x = 25
player2 = Fighter_a:new()
player2.name = 'player2'
player2.x = 500
players = {}
table.insert(players, player1) 
table.insert(players, player2)
world:add(player1.name, player1.x, player1.y, player1.hitboxHeight, player1.hitboxWidth)
world:add(player2.name, player2.x, player2.y, player2.hitboxHeight, player2.hitboxWidth)

--stage selection

--load graphics
stage_bg = love.graphics.newImage( "img/test_stage_bg.png" )

--create object container
obj_container = {}

end

--BEGIN UPDATES
function love.update(dt)
dt = 1
--BUILD START MENU
--BUILD CHARACTER SELECT MENU
--SET MATCH PARAMETERS

--BEGIN SETUP MATCH

--END SETUP MATCH

--BEGIN START FIGHT loop

-- player input control logic
if player1.state.ready == 1
then
function love.keypressed( key )
   if key == "left" then
      player1.state.move_left = 1
   end
   if key == "right" then
      player1.state.move_right = 1
   end
   if key == "up" then
      player1.state.jump = 1
   end
   if key == "down" then
      player1.state.crouch = 1
   end
end
 
function love.keyreleased( key )
   if key == "left" then
      player1.state.move_left = 0
   end
   if key == "right" then
      player1.state.move_right = 0
   end
   if key == "up" then
      player1.state.jump = 0
   end
   if key == "down" then
      player1.state.crouch = 0
   end
end

	if love.keyboard.isDown("a")then
		  player1.state.s_punch = 1
		  player1.state.attacking = 1
	end  
	if love.keyboard.isDown("s")then
		  player1.state.s_kick = 1
		  player1.state.attacking = 1
	end
	if love.keyboard.isDown("d")then
	  	player1.state.gaurd = 1
    end  
end

--player state logic   
for itA,pl in ipairs(players)
	do
	
	--running Update function see character/Fighter class
	pl:update()

	--player attack hitbox creation
	if next(pl.attack_data) ~= nil
	then
		if pl.attack_data.c_frame == pl.attack_data.hitbox_frame 
		then	
		world:add( pl.name .."_hitbox", pl.attack_data.hitbox_x, pl.attack_data.hitbox_y, pl.attack_data.hitbox_height, pl.attack_data.hitbox_width )
		else
		world:remove(pl.name .. "_hitbox")
		end
	end
	
end

--at the end of state logic need to keep track of player1 and player2 inputs
		
--BEGIN attack logic
--[[COMBO logic
no meter 5 hit combo
1 bar meter 10 hit combo -> 6% damage
2 bar meter 15 hit combo -> 15% damage
3 bar meter 20 hit combo -> 35% damage
next button sequence appears to extend the combo (randomized and time limit)
you need meter to extend a combo pass 10 hits
if you drop the combo before the end of the bar extension you started you loose the bar
ending a bar extension adds the remaining 50% damage
the opponent can only break a combo if he has at least 1 bar of meter
END COMBO logic]]
--END attack logic

--BEGIN COLLISION DETECTION
--BEGIN COLLISION DETECTION
--BEGIN COLLISION DETECTION
--add new elements to the world
if next(obj_container) ~= nil
then
	for itB,obj in ipairs(obj_container)
		do
		
		world:add(obj.name, obj.x, obj.y, obj.height, obj.width)

	end
end

--move elements

--checking player1 collision logic

  local goalX, goalY = player1.x + player1.velocity_x, player1.y + player1.velocity_y
  local actualX, actualY, cols, len = world:move(player1.name, goalX, goalY)
  player1.x, player1.y = actualX, actualY
  for i=1,len do
    local other = cols[i].other
    if other.player2_hitbox then
    --player1 guard logic								
		if (player1.state.guard ~= 1)
		then
			player1.state.hit = 1
			--check stun properties of player2's attack apply to player1 cooldown timer
			--stun player1
			player1.cooldown = 0
			player2.attack_data.stun_frames = player1.cooldown
			player1.state.stuned = 1
			player1.hitpoints = player1.hitpoints - player2.attack_data.damage
		else
		player1.state.blocked = 1
		end

    end
  end


--remove end of life elements
	
--END COLLISION DETECTION	
	
--END UPDATES
end


--DRAWING
function love.draw()
 
	--draw background 1st
	love.graphics.draw(stage_bg)

	--draw HUD (healthbar, timer, meter)

	--drawing players
	for itC,pl in ipairs(players)
	do
		--[[iterate through player table draw based on state]]

		love.graphics.setColor(255, 255, 255) --white
	    love.graphics.rectangle("fill", pl.x, pl.y, pl.width, pl.height)
	    
	    --only needed for testing hitbox placement
	    local result = world:hasItem(pl.name .. "_hitbox")
	    	if result == true
	    	then
	    		love.graphics.setColor(255,0,0) --red
	    	    love.graphics.rectangle("fill", pl.attack_data.hitbox_x, pl.attack_data.hitbox_y, pl.attack_data.hitbox_height, pl.attack_data.hitbox_width)
	    	end
	    	
	end

	--drawing objects
	if next(obj_container) ~= nil
	then
			for itD,obj in ipairs(obj_containter)
			do
			--[[iterate through object container for drawing{
		draw based on object state & position, ]]

			love.graphics.rectangle("fill", obj.x, obj.y, obj.width, obj.height)

			end
	end


 end		


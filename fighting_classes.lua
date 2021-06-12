-- Object Base Class
Object = {

	name = "",
    x = 100,
    y = 200,
    vx = 0,
    xy = 0,
    left = 0,
    top = 0,
    height = 16,
    width = 16
}


function Object:new(o)
    o=o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end


-- Character Class
Character = Object:new()

function Character:new(o)

    o=o or Object:new(o)
    o.direction = 1
    o.velocity_x = 0
    o.velocity_y = 0
    o.left = 0
    o.top = 0
    o.width = 64
    o.height = 128
    o.hitboxWidth = 64
    o.hitboxHeight = 128
    o.hitboxCrouchingHeight = 16
	o.hitpoints = 100
    o.spr = 'characters'
	o.cooldown = 0
	o.attack_data = {
	}
	
	o.state = {
		--add extra stuns frames if hit while attacking state is active
		attacking = 0,
		hit = 0,
		stuned = 0,
		ready = 1,
		blocked = 0,
		guard = 0,
		knockdown = 0,
		dead = 0,
		s_punch = 0,
		s_kick = 0,
		crouch = 0,
		jump = 0,
		move_right = 0,
		move_left = 0
	
	}
	
    o.vel = {

        x = 0,
        xMaxSpeed = 1,
        y = 0,

    }
	
    setmetatable(o,self)
    self.__index = self
    return o

end

-- Test Fighter Class
Fighter_a = Character:new()

function Fighter_a:new(o)
    o=o or Character:new(o)

	o.s_punch = {
		name = "s_punch",
		hitbox_x = o.x + 20,
		hitbox_y = o.y,
		hitbox_height = 25,
		hitbox_width = 25,
		c_frame = 1,
		hitbox_frame = 2,
		damage = 5,
		startup_frames = 1,
		recovery_frames = 4,
		stun_frames = 2
	}
	
	o.s_kick = {
		name = "s_kick",
		hitbox_x = o.x + 30,
		hitbox_y = o.y,
		hitbox_height = 25,
		hitbox_width = 25,
		c_frame = 1,
		hitbox_frame = 3,
		damage = 7,
		startup_frames = 2,
		recovery_frames = 6,
		stun_frames = 3
	}
	
	
	o.sprite_sheet = "img/fighter1.png"
	
	o.animation = {}
	o.animation.s_punch = {}
	--frame location
	o.animation.s_punch[1]= {
				x = 0,
				y = 0,
				height = 16,
				width = 16
			}

	o.animation.s_punch[2] = {
				x = 16,
				y = 0,
				height = 16,
				width = 16
			}

	setmetatable(o,self)
	self.__index = self
	return o

end		
		


function Fighter_a:update()

	if self.state.move_right == 1
		then
		self.x = self.x + 1
	end

	if self.state.move_left == 1
		then
		self.x = self.x - 1
	end

	--player control cooldown logic
	if self.cooldown > 0
		then
		self.state.ready = 0
		--reduce the cooldown every frame
		self.cooldown = self.cooldown - 1
	else
		if next(self.attack_data) ~= nil
			then
			--reset the attack state to 0
			self.state[self.attack_data.name] = 0
			self.state.attacking = 0
			--removing old attack data
			count = #self.attack_data
			for i=0, count do self.attack_data[i]=nil
			end
			--character can be controlled agian
			self.ready = 1
		end
	end
	
	if self.state.gaurd == 1
		then
		self.state.ready = 0
	end

	if self.state.s_punch == 1 
		then
		if self.cooldown == 0
			then
			self.attack_data = self.s_punch
			self.cooldown = self.ttack_data.recovery_frames
		elseif self.cooldown >= 1 and self.cooldown <= self.attack_data.recovery_frames
		then
		self.attack_data.c_frame = self.attack_data.c_frame + 1
		end
	end

	if self.state.s_kick == 1
		then
		
		if self.cooldown == 0
		then
			self.attack_data = self.s_kick
			self.cooldown = self.attack_data.recovery_frames
			elseif self.cooldown >= 1 and self.cooldown <= self.attack_data.recovery_frames
			then
			self.c_frame = self.c_frame + 1
		end
	end
end

function Fighter_a:draw()
	if self.state.attacking == 1 
		then
		--play animation using attack name
		local animation_table = self.animation[self.attack_data.name]
	end
end



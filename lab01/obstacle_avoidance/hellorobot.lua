-- Put your global variables here

MOVE_STEPS = 100
MAX_VELOCITY = 10
LIGHT_THRESHOLD = 1.5

n_steps = 0


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
	-- robot.leds.set_all_colors("black")
end



--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()
	n_steps = n_steps + 1
	if n_steps % MOVE_STEPS == 0 then
		left_v = robot.random.uniform(0,MAX_VELOCITY)
		right_v = robot.random.uniform(0,MAX_VELOCITY)
	end
	robot.wheels.set_velocity(left_v,right_v)
	log("robot.position.x = " .. robot.positioning.position.x)
	log("robot.position.y = " .. robot.positioning.position.y)
	log("robot.position.z = " .. robot.positioning.position.z)
	light_front = robot.light[1].value + robot.light[24].value
	log("robot.light_front = " .. light_front)
--[[
	ground = robot.motor_ground --just to save some chars...
	log("ground NW: " .. ground[1].value)
	log("ground SW: " .. ground[2].value)
	log("ground SE: " .. ground[3].value)
	log("ground NE: " .. ground[4].value)
]]
	-- Check if close to obstacle
	for i=1,#robot.proximity do
		if robot.proximity[i].value > 0.1
			robot.wheels.set_velocity(MAX_VELOCITY/2, -MAX_VELOCITY/2)
		else
			robot.wheels.set_velocity(left_v, right_v)
		end
	end
	-- Check if on spot
--[[
	spot = false
	for i=1,4 do
		if ground[i].value == 0 then
			spot = true
			break
		end
	end
]]

	--[[ Check if close to light 
	(note that the light threshold depends on both sensor and actuator characteristics) ]]
--[[
	light = false
	sum = 0
	for i=1,#robot.light do
		sum = sum + robot.light[i].value
	end
	if sum > LIGHT_THRESHOLD then
		light = true
		robot.wheels.set_velocity(0,0)
	end


	if spot == true then
		robot.leds.set_all_colors("red")
	elseif light == true then
		robot.leds.set_all_colors("yellow")
	else
		robot.leds.set_all_colors("black")
	end
]]

end



--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
	--robot.leds.set_all_colors("black")
end



--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end

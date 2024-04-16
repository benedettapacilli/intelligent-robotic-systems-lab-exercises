-- Put your global variables here

MOVE_STEPS = 100
MAX_VELOCITY = 10
LIGHT_THRESHOLD = 1

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
	--ground = robot.motor_ground --just to save some chars...
	--log("ground NW: " .. ground[1].value)
	--log("ground SW: " .. ground[2].value)
	--log("ground SE: " .. ground[3].value)
	--log("ground NE: " .. ground[4].value)
	
	-- Search for the reading with the highest value
	--value = -1 -- highest value found so far
	--idx = -1   -- index of the highest value
	--for i=1,#robot.proximity do
	--	if value < robot.proximity[i].value then
	--		idx = i
	--		value = robot.proximity[i].value
	--	end
	--end
	--log("robot max proximity sensor: " .. idx .. "," .. value)

	-- Check if on spot
	--spot = false
	--for i=1,4 do
	--	if ground[i].value == 0 then
	--		spot = true
	--		break
	--	end
	--end


	--[[ Check if close to light 
	(note that the light threshold depends on both sensor and actuator characteristics) ]]
	light = false
	max_value = -1
	max_value_idx = -1
	for i=1,#robot.light do
		if robot.light[i].value > max_value then
			max_value = robot.light[i].value
			max_value_idx = i
		end
	end
	
	-- Move towards the direction of the max value
	if max_value_idx ~= -1 then
		left_v = MAX_VELOCITY
		right_v = MAX_VELOCITY
		if max_value_idx <= #robot.light / 2 then
			left_v = 0
		else
			right_v = 0
		end
		robot.wheels.set_velocity(left_v,right_v)
	end

	--if spot == true then
	--	robot.leds.set_all_colors("red")
	--elseif light == true then
	--	robot.leds.set_all_colors("yellow")
	--else
	--	robot.leds.set_all_colors("black")
	--end


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

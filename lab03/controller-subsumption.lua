OBSTACLE_THRESHOLD = 0.1
LIGHT_THRESHOLD = 0.55
MAX_VELOCITY = 15
MOVE_STEPS = 200

function limit_velocity(v)
    if v > MAX_VELOCITY then
      return MAX_VELOCITY
    elseif v < -MAX_VELOCITY then
      return -MAX_VELOCITY
    else
      return v
    end
  end

function init()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(limit_velocity(left_v),limit_velocity(right_v))
	n_steps = 0
end

function obstacle_avoidance()
    max_prox = -1
    max_prox_idx = -1
    for i=1,#robot.proximity do
        if robot.proximity[i].value > max_prox then
            max_prox = robot.proximity[i].value
            max_prox_idx = i
        end
    end

    if max_prox_idx ~= -1 then
        left_v = MAX_VELOCITY
        right_v = MAX_VELOCITY
		if max_prox > OBSTACLE_THRESHOLD then

            if max_prox_idx <= #robot.proximity / 2 then
                right_v = robot.random.uniform(0,3)
            else
                left_v = robot.random.uniform(0,3)
            end
            
            robot.wheels.set_velocity(limit_velocity(left_v),limit_velocity(right_v))
        else 
            photo_taxis()
        end
    end
end

function photo_taxis()
    max_value = -1
	max_value_idx = -1
	for i=1,#robot.light do
		if robot.light[i].value > max_value then
			max_value = robot.light[i].value
			max_value_idx = i
		end
	end

    if max_value >= LIGHT_THRESHOLD then
        robot.wheels.set_velocity(0,0)
	elseif (max_value < LIGHT_THRESHOLD and max_value > 0.1) then
		left_v = MAX_VELOCITY
		right_v = MAX_VELOCITY
		if max_value_idx <= #robot.light / 2 then
			left_v = 0
		else
			right_v = 0
		end
		robot.wheels.set_velocity(limit_velocity(left_v),limit_velocity(right_v))
        return true
	else
		explore()
	end
end

function explore()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
    right_v = robot.random.uniform(0,MAX_VELOCITY)
    robot.wheels.set_velocity(limit_velocity(left_v),limit_velocity(right_v))
end

function step()
    n_steps = n_steps + 1
    obstacle_avoidance()
    if n_steps > MOVE_STEPS then
        reset()
    end
end

function reset()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(limit_velocity(left_v),limit_velocity(right_v))
	n_steps = 0
end

function destroy()
    x = robot.positioning.position.x
    y = robot.positioning.position.y
    d = math.sqrt((x-1.5)^2 + y^2)
    print('f_distance ' .. d)
  end
MOVE_STEPS = 100
MAX_VELOCITY = 15
LIGHT_THRESHOLD = 0.3

n_steps = 0

function init()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end

function step()
	n_steps = n_steps + 1

    max_prox = -1
    max_prox_idx = -1
    for i=1,#robot.proximity do
        if robot.proximity[i].value > max_prox then
            max_prox = robot.proximity[i].value
            max_prox_idx = i
        end
    end
    
    left_v = MAX_VELOCITY
    right_v = MAX_VELOCITY
	if max_prox > 0 then
            if max_prox_idx <= #robot.proximity / 2 then
                right_v = robot.random.uniform(0,3)
            else
                left_v = robot.random.uniform(0,3)
            end
            robot.wheels.set_velocity(left_v,right_v)
    else 
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
        elseif (max_value < LIGHT_THRESHOLD and max_value > 0) and max_value_idx ~= -1 then
            if max_value_idx <= #robot.light / 2 then
                left_v = 0
            else
                right_v = 0
            end
            robot.wheels.set_velocity(left_v,right_v)
        else
            robot.wheels.set_velocity(robot.random.uniform(0,MAX_VELOCITY),robot.random.uniform(0,MAX_VELOCITY))
        end
    end

end

function reset()
	left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
	n_steps = 0
end

function destroy()
    x = robot.positioning.position.x
    y = robot.positioning.position.y
    d = math.sqrt((x-1.5)^2 + y^2)
    print('f_distance ' .. d)
end

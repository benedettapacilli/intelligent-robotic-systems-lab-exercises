MAX_VELOCITY = 15
MOVE_STEPS = 200
LIGHT_THRESHOLD = 0.55

vector = require("vector")

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
	robot.wheels.set_velocity(left_v,right_v)
    L = robot.wheels.axis_length
	n_steps = 0
end

function obstacle_avoidance()
    if light_flag then
        return {length = 0, angle = 0}
    end
    proximity_sensors = robot.proximity
    max_value = -1
    max_angle = -1
    index = -1
    v = {length = 0, angle = 0}
    for i = 1, #proximity_sensors do
        if proximity_sensors[i].value > max_value then
            max_value = proximity_sensors[i].value
            max_angle = proximity_sensors[i].angle
            index = i
        end
    end
    if max_value ~= -1 then
        if index <= #robot.proximity / 2 then
            v = {length = MAX_VELOCITY * max_value, angle = max_angle - (math.pi/2)}
        else
            v = {length = MAX_VELOCITY * max_value, angle = max_angle + (math.pi/2)}
        end
    end
    return v
end

function phototaxis(light_flag)
    if light_flag then
        return {length = 0, angle = 0}
    end
    light_sensors = robot.light
    max_value = -1
    max_angle = -1
    v = {length = 0, angle = 0}
    for i = 1, #light_sensors do
        if light_sensors[i].value > max_value then
            max_value = light_sensors[i].value
            max_angle = light_sensors[i].angle
        end
    end
    if max_value > 0.01 then
        v = {length = limit_velocity(MAX_VELOCITY / max_value), angle = max_angle}
    else 
        v = {length = robot.random.uniform(5, MAX_VELOCITY), angle = robot.random.uniform(-math.pi, math.pi)}
    end
    return v
end

function check_lighting()
    for i = 1, #robot.light do
        if robot.light[i].value >= LIGHT_THRESHOLD then
            return true
        end
    end
    return false
end


function step()
    n_steps = n_steps + 1
    light_flag = check_lighting()
    v_obstacle_avoidance = obstacle_avoidance(light_flag)
    v_phototaxis = phototaxis(light_flag)

    v_final = vector.vec2_polar_sum(v_phototaxis, v_obstacle_avoidance)

    left_v = 1 * v_final.length + (-L/2) * v_final.angle
    right_v = 1 * v_final.length + (L/2) * v_final.angle
    robot.wheels.set_velocity(left_v, right_v)

    if n_steps > MOVE_STEPS then
        reset()
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

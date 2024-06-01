MAX_VELOCITY = 10
MOVE_STEPS = 200
LIGHT_THRESHOLD = 0.55

vector = require("vector")

function init()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
    L = robot.wheels.axis_length
	n_steps = 0
end

function obstacle_avoidance()
    if light_flag then
        v = {length = 0, angle = 0}
        return v
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
            index = 1
        end
    end
    if max_value ~= -1 then
        if index <= #robot.proximity / 2 then
            v = {length = MAX_VELOCITY, angle = max_angle - math.pi}
        else
            v = {length = MAX_VELOCITY, angle = max_angle + math.pi}
        end
    end
    return v
end

function phototaxis(light_flag)
    if light_flag then
        v = {length = 0, angle = 0}
        return v
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
    if max_value ~= -1 then
        v = {length = MAX_VELOCITY, angle = max_angle} -- max_value * 
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
end

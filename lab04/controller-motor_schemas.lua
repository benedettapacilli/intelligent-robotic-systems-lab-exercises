MAX_VELOCITY = 15
MOVE_STEPS = 200

vector = require("vector")

function init()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
    L = robot.wheels.axis_length
	n_steps = 0
end

function obstacle_avoidance()
    proximity_sensors = robot.proximity
    max_value = -1
    v = {length = 0, angle = 0}
    for i = 1, #proximity_sensors do
        if proximity_sensors[i].value > max_value then
            max_value = proximity_sensors[i].value
            if i >= 1 or i <= 12 then
                v = {length = proximity_sensors[i].value / max_value, angle = proximity_sensors[i].angle - math.pi}
            else
                v = {length = proximity_sensors[i].value / max_value, angle = proximity_sensors[i].angle + math.pi}
            end
        end
    end
    return v
end

function phototaxis()
    light_sensors = robot.light
    max_value = -1
    v = {length = 0, angle = 0}
    for i = 1, #light_sensors do
        if light_sensors[i].value > max_value then
            max_value = light_sensors[i].value
            v = {length = ((light_sensors[i].value) * 10) / max_value, angle = light_sensors[i].angle}
        end
    end
    return v
end


function step()
    n_steps = n_steps + 1
    v_obstacle_avoidance = obstacle_avoidance()
    v_phototaxis = phototaxis()

    v_final = vector.vec2_polar_sum(v_phototaxis, v_obstacle_avoidance)

    left_v = 1 * v_phototaxis.length + (-L/2) * v_phototaxis.angle
    right_v = 1 * v_phototaxis.length + (L/2) * v_phototaxis.angle
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
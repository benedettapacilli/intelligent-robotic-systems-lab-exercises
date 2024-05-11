S = 0.01
W = 0.1
P_s_max = 0.99
P_w_min = 0.005
alpha = 0.1
beta = 0.05

MAX_VELOCITY = 15
MOVE_STEPS = 1000
OBSTACLE_THRESHOLD = 0.5
MAXRANGE = 30

state = 0 -- 0 moving, 1 stopped
--red stopped, green moving

function init()
    left_v = robot.random.uniform(0,MAX_VELOCITY)
	right_v = robot.random.uniform(0,MAX_VELOCITY)
	robot.wheels.set_velocity(left_v,right_v)
    n_steps = 0
    robot.leds.set_single_color(13, "green")
end

function random_stop(number_robot_sensed)
    P_s = math.min(P_s_max, S+(alpha*number_robot_sensed))
    t = robot.random.uniform()
    if t <= P_s then
        robot.wheels.set_velocity(0,0)
        state = 1
        robot.leds.set_single_color(13, "red")
    end
end

function random_walk(number_robot_sensed)
    P_w = math.max(P_w_min, W - (beta*number_robot_sensed))
    t = robot.random.uniform()
    if t <= P_w then
        robot.wheels.set_velocity(robot.random.uniform(0, MAX_VELOCITY), robot.random.uniform(0, MAX_VELOCITY))
        state = 0
        robot.leds.set_single_color(13, "green")
    end
end

function signal_presence(value)
    robot.range_and_bearing.set_data(1,value)
end

function CountRAB()
    number_robot_sensed = 0
    for i = 1, #robot.range_and_bearing do
        -- for each robot seen, check if it is close enough.
        if robot.range_and_bearing[i].range < MAXRANGE and robot.range_and_bearing[i].data[1]==1 then
            number_robot_sensed = number_robot_sensed + 1
        end
    end
        return number_robot_sensed
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
            
            robot.wheels.set_velocity(left_v,right_v)
        end
    end
end

function step()
    n_steps = n_steps + 1
    number_robot_sensed = CountRAB()
    random_stop(number_robot_sensed)
    random_walk(number_robot_sensed)
    signal_presence(state)
    if (state) then
        obstacle_avoidance()
    end
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
    --
  end
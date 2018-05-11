from collections import namedtuple, deque
import random
import math
import json
import sys

Vertex = namedtuple('Vertex', ['id', 'x', 'y', 'neighbors'])
# neighbors - list of id


class VertexPool:
    RAD = 0.000008998719243599958

    def __init__(self, filename):
        self._load_from_file(filename)

    def lat_to_meters(self, lat):
        return (lat - self.min_lat) / self.RAD

    def lon_to_meters(self, lon):
        return (lon - self.min_lon) / self.RAD

    def y_to_lat(self, y):
        return y * self.RAD + self.min_lat

    def x_to_lon(self, x):
        return x * self.RAD + self.min_lon

    def _load_from_file(self, filename):
        data = json.load(open(filename, 'r'))
        self.min_lat = data['min_latitude']
        self.min_lon = data['min_longitude']

        self.vertices = [Vertex(vertex['id'], vertex['x'], vertex['y'], vertex['neighbours']) for vertex in data['vertices']]

    def __len__(self):
        return len(self.vertices)

    def __getitem__(self, item):
        return self.vertices[item]


Position = namedtuple('Position', ['x','y'])


class PlanPoint:
    def __init__(self, vertex, turn_angle, max_turn_speed, distance_from_current_point):
        self.vertex = vertex
        self.turn_angle = turn_angle
        self.max_turn_speed = max_turn_speed
        self.distance_from_current_point = distance_from_current_point


def distance(start: Position, end: Position):
    return math.sqrt((end.x - start.x) ** 2 + (end.y - start.y) ** 2)


def calc_angle(prev, cur, next):
    turn_angle = math.atan2(cur.y - prev.y, cur.x - prev.x) - math.atan2(next.y - cur.y, next.x - cur.x)
    if turn_angle > math.pi:
        turn_angle -= 2 * math.pi
    if turn_angle < -math.pi:
        turn_angle += 2 * math.pi
    return turn_angle


class TurnSignal:
    DISABLED = 0
    LEFT = 1
    RIGHT = 2
    EMERGENCY = 3


class Emulator:
    KMPH_TO_MPS = 0.277777777777
    MPS_TO_KMPH = 1 / KMPH_TO_MPS

    MAX_SPEED = 25  # meters per second ~ 90 kmph
    MIN_SPEED = 2.77777710  # meters per second ~ 10 kmph
    MAX_TURN_AROUND_SPEED = MIN_SPEED  # Must be equals or greater than MIN_SPEED
    MAX_ACCELERATION = 2.77777  # meters per second
    MIN_ACCELERATION = 0.5
    MAX_BREAK = 4
    MIN_BREAK = 1
    INITIAL_SPEED = 0
    PLAN_LENGTH = 10  # minimum 3 for previous, current and next points

    MADNESS_CHANGE_TICKS = 400  # ticks till driver madness changes
    ACCELERATION_TO_FUEL_CONSUMPTION_RATIO = 2.59  # acceleration * ACCELERATION_TO_FUEL_CONSUMPTION_RATIO (liters per 100km)
    MIN_FUEL_CONSUMPTION = 4  # liters per 100km
    LINE_WIDTH = 1.5
    LINE_CHANGE_CHANCE = 0.01

    STOP_SIGNAL_BREAK_THRESHOLD = 0.5
    TURN_SIGNAL_TICKS = 8
    TURN_SIGNAL_ANGLE_THRESHOLD = 0.8726646259971648  # 50 degrees
    TURN_SIGNAL_DISTANCE = 20

    MIN_RPM = 800
    SPEED_TO_TURN_GEAR = 5.1

    def __init__(self, vertex_pool: VertexPool):
        self._tick = 0
        self._vertex_pool = vertex_pool
        self._acceleration = 0
        self._turn_angle = 0
        self._speed = self.INITIAL_SPEED
        self._max_speed = self.MAX_SPEED
        self._max_break = self.MAX_BREAK
        self._max_acceleration = self.MAX_ACCELERATION
        self._madness = 0.7
        self._plan = deque()
        self._turn_signal_countdown = 0
        self._turn_signal = TurnSignal.DISABLED
        self.madness = 0.7
        self.change_madness_periodically = True
        self._ticks_till_next_madness = self.MADNESS_CHANGE_TICKS
        self._line_offset = 0  # negative means offset to left from center
        self.command_to_stop = False
        self._init_plan()
        self._x = self._prev.x
        self._y = self._prev.y

        self._angle = math.atan2(self._current.y - self._prev.y, self._current.x - self._prev.x)
        self._distance_till_turn = distance(self._prev, self._current)

    def _init_plan(self):
        self._plan = deque()

        # prev
        prev_vertex = random.choice(self._vertex_pool)
        self._plan.append(PlanPoint(prev_vertex, 0, 0, 0))

        # cur
        cur_vertex = self._get_random_next_vertex(self._plan[0].vertex)
        self._plan.append(PlanPoint(cur_vertex, 0, 0, 0))

        for _ in range(self.PLAN_LENGTH-2):
            self._add_point_to_plan()

    def _add_point_to_plan(self):
        prev = self._plan[-2]
        cur = self._plan[-1]
        next_vertex = self._get_random_next_vertex(self._plan[-1].vertex, self._plan[-2].vertex)

        cur.turn_angle = calc_angle(prev.vertex, cur.vertex, next_vertex)
        cur.max_turn_speed = self._calc_max_turn_speed(cur.turn_angle)

        distance_from_current_point = cur.distance_from_current_point + distance(cur.vertex, next_vertex)
        self._plan.append(PlanPoint(next_vertex, 0, 0, distance_from_current_point))

    def _get_random_next_vertex(self, current, prev=None):
        possible_next_ids = list(current.neighbors)
        if prev and len(possible_next_ids) >= 2 and prev.id in possible_next_ids:
            possible_next_ids.remove(prev.id)
        next_id = random.choice(possible_next_ids)
        return self._vertex_pool[next_id]

    def _calc_max_turn_speed(self, turn_angle):
        max_speed_for_curr_turn_angle = (self.MAX_SPEED - self.MAX_TURN_AROUND_SPEED) * (1 - abs(turn_angle) / math.pi)
        max_turn_speed = self.MIN_SPEED + (max_speed_for_curr_turn_angle - self.MIN_SPEED) * self.madness
        return max_turn_speed

    def update(self, time_delta=1.0):
        assert time_delta > 0
        self._tick += 1
        self._check_turn_signal_to_disable()
        self._update_madness_if_needed()

        if self.command_to_stop:
            self._enable_turn_signal(TurnSignal.EMERGENCY)
            self._break(time_delta, emergency=True)
        elif self._want_to_break(time_delta):
            self._break(time_delta)
            self._show_turn_signal_if_needed()
        else:
            self._accelerate(time_delta)
            self._show_turn_signal_if_needed()

        if self._is_time_to_turn(time_delta):
            self._turn_and_move(time_delta)
        else:
            self._change_line(time_delta)
            self._move(self._speed, time_delta)

        self._distance_till_turn = distance(Position(self._x, self._y), self._current)

    def _check_turn_signal_to_disable(self):
        if self._turn_signal_countdown:
            self._turn_signal_countdown -= 1
            if self._turn_signal_countdown == 0:
                self._turn_signal = TurnSignal.DISABLED

    def _want_to_break(self, time_delta):
        speed_at_next_tick = self._speed + self._calc_acceleration_value(time_delta)
        plan_iter = iter(self._plan)
        next(plan_iter)  # skip first
        for plan_point in plan_iter:
            max_turn_speed = plan_point.max_turn_speed
            distance_till_turn = self._distance_till_turn + plan_point.distance_from_current_point

            time_to_stop = (speed_at_next_tick - max_turn_speed) / self._max_break
            distance_to_stop = speed_at_next_tick * time_to_stop - self._max_break * time_to_stop ** 2 / 2
            if distance_to_stop > distance_till_turn:
                return True
        return False

    def _accelerate(self, time_delta):
        self._acceleration = self._calc_acceleration_value(time_delta)
        self._speed += self._acceleration * time_delta

    def _calc_acceleration_value(self, time_delta):
        """
        accelerate or break to move with speed equals max_speed
        -MAX_BREAK <= accelerate <= max_acceleration
        """
        calculated_acceleration = (self._max_speed - self._speed) / time_delta
        return max(-self.MAX_BREAK, min(self._max_acceleration, calculated_acceleration))

    def _break(self, time_delta, emergency=False):
        if emergency:
            calculated_acceleration = (0 - self._speed) / time_delta
            self._acceleration = max(-self.MAX_BREAK, calculated_acceleration)
        else:
            self._acceleration = -self._break_value()
        self._speed += self._acceleration * time_delta
        self._speed = max(0, self._speed)

    def _break_value(self):
        """
        calc break_value to get speed equals max_turn_speed for each plan_point
        and return maximum value.
        In common cases it should return value in range: 0 <= value <= max_break
        because method _want_to_break calculating using value max_break
        but in emergency cases or when madness suddenly decreased just before the crossroad
        return value will be in range 0 <= value <= MAX_BREAK
        """
        max_a = 0
        plan_iter = iter(self._plan)
        next(plan_iter)  # skip first
        for plan_point in plan_iter:
            max_turn_speed = plan_point.max_turn_speed
            distance_till_turn = self._distance_till_turn + plan_point.distance_from_current_point

            v_delta = max(self._speed - max_turn_speed, 0)
            if distance_till_turn != 0:
                a = (self._speed * v_delta - v_delta ** 2 / 2) / distance_till_turn
            else:
                a = 0

            # a - always positive, because self.speed > v_delta / 2
            a = min(a, self.MAX_BREAK)
            max_a = max(max_a, a)

        return max_a

    def _is_time_to_turn(self, time_delta):
        return self._speed * time_delta > self._distance_till_turn

    def _turn_and_move(self, time_delta):
        assert self._speed > 0
        move_distance = self._speed * time_delta
        while move_distance > self._distance_till_turn:
            self._move(self._distance_till_turn, 1)
            move_distance -= self._distance_till_turn
            self._x = self._current.x
            self._y = self._current.y
            self._turn_angle = self._current_turn_angle
            self._angle = math.atan2(self._next.y - self._current.y, self._next.x - self._current.x)
            self._update_plan()
            self._distance_till_turn = distance(Position(self._x, self._y), self._current)
        self._move(move_distance, 1)

    def _change_line(self, time_delta):
        if self._speed >= self.MIN_SPEED:
            direction = self._get_change_line_direction()
        else:
            direction = 0

        if direction != 0:
            forw_speed = self._speed * time_delta
            self._turn_angle = math.atan2(direction * self.LINE_WIDTH, forw_speed)
            self._line_offset += direction
            self._enable_turn_signal(TurnSignal.LEFT if direction < 0 else TurnSignal.RIGHT)
        else:
            self._turn_angle = 0

    def _get_change_line_direction(self):
        if self.command_to_stop:
            if self._line_offset < 1:
                return 1
        else:
            if random.random() < self.LINE_CHANGE_CHANCE:
                return random.choice([-1, 1]) if self._line_offset == 0 else -self._line_offset
        return 0

    def _show_turn_signal_if_needed(self):
        if abs(self._current_turn_angle) > self.TURN_SIGNAL_ANGLE_THRESHOLD \
                and self._distance_till_turn < self.TURN_SIGNAL_DISTANCE:
            self._enable_turn_signal(TurnSignal.LEFT if self._current_turn_angle < 0 else TurnSignal.RIGHT)

    def _enable_turn_signal(self, turn_signal):
        self._turn_signal_countdown = self.TURN_SIGNAL_TICKS
        self._turn_signal = turn_signal

    def _move(self, speed, time_delta):
        self._x += math.cos(self._angle) * speed * time_delta
        self._y += math.sin(self._angle) * speed * time_delta

    def _calc_turn_angle_to_next_point(self):
        next_angle = math.atan2(self._next.y - self._current.y, self._next.x - self._current.x)
        turn_angle = self._angle - next_angle
        if turn_angle > math.pi:
            turn_angle -= 2 * math.pi
        if turn_angle < -math.pi:
            turn_angle += 2 * math.pi
        return turn_angle

    def _update_plan(self):
        self._plan.popleft()
        delta_distance = distance(self._plan[0].vertex, self._plan[1].vertex)
        plan_iter = iter(self._plan)
        next(plan_iter)  # skip first
        for plan_point in plan_iter:
            plan_point.distance_from_current_point -= delta_distance
        self._add_point_to_plan()

    def _update_madness_if_needed(self):
        if self.change_madness_periodically:
            self._ticks_till_next_madness -= 1
            if self._ticks_till_next_madness == 0:
                self.madness = random.random() * 0.5 + 0.5

    def get_data(self):
        return {
            "speed": float(self.speed),
            "turn_angle": float(self.turn_angle),
            "acceleration": float(self.acceleration),
            "lat": float(self.lat),
            "long": float(self.lon),
            "fuel_consumption": float(self.fuel_consumption),
            "stop_signal": self.stop_signal,
            "turn_signal": self.turn_signal,
            "gear": self.gear,
            "rpm": self.rpm,
        }

    @property
    def x(self):
        if self._line_offset == 0:
            return self._x

        angle = self._angle + (math.pi / 2 if self._line_offset < 0 else -math.pi / 2)
        dx = math.cos(angle) * abs(self._line_offset) * self.LINE_WIDTH
        return self._x + dx

    @property
    def y(self):
        if self._line_offset == 0:
            return self._y

        angle = self._angle + (math.pi / 2 if self._line_offset < 0 else -math.pi / 2)
        dy = math.sin(angle) * abs(self._line_offset) * self.LINE_WIDTH
        return self._y + dy

    @property
    def _current_turn_angle(self):
        return self._plan[1].turn_angle

    @property
    def _prev(self):
        return self._plan[0].vertex

    @property
    def _current(self):
        return self._plan[1].vertex

    @property
    def _next(self):
        return self._plan[2].vertex

    @property
    def madness(self):
        return self._madness

    @madness.setter
    def madness(self, madness):
        assert 0 < madness <= 1
        self._madness = madness
        self._max_speed = self.MIN_SPEED + (self.MAX_SPEED - self.MIN_SPEED) * madness
        self._max_acceleration = self.MIN_ACCELERATION + (self.MAX_ACCELERATION - self.MIN_ACCELERATION) * madness
        self._max_break = self.MIN_BREAK + (self.MAX_BREAK - self.MIN_BREAK) * madness
        for cur in iter(self._plan):
            cur.max_turn_speed = self._calc_max_turn_speed(cur.turn_angle)
        self._ticks_till_next_madness = self.MADNESS_CHANGE_TICKS

    @property
    def lat(self):
        return self._vertex_pool.y_to_lat(self.y)

    @property
    def lon(self):
        return self._vertex_pool.x_to_lon(self.x)

    @property
    def fuel_consumption(self):
        return self.rpm * self.MIN_FUEL_CONSUMPTION / self.MIN_RPM

    @property
    def acceleration(self):
        return self._acceleration

    @property
    def turn_angle(self):
        return self._turn_angle

    @property
    def angle(self):
        return self._angle

    @property
    def speed(self):
        return self._speed

    @property
    def max_speed(self):
        return self._max_speed

    @property
    def max_break(self):
        return self._max_break

    @property
    def max_acceleration(self):
        return self._max_acceleration

    @property
    def vertex_pool(self):
        return self._vertex_pool

    @property
    def tick(self):
        return self._tick

    @property
    def stop_signal(self):
        return self.acceleration <= -self.STOP_SIGNAL_BREAK_THRESHOLD

    @property
    def turn_signal(self):
        return self._turn_signal

    @property
    def gear(self):
        if self.speed < self.MIN_SPEED and self.command_to_stop:
            return 0
        else:
            return min(int(self.speed // self.SPEED_TO_TURN_GEAR), 4) + 1

    @property
    def rpm(self):
        if self.gear == 0:
            return self.MIN_RPM
        elif self.gear == 1:
            return int((self.speed % self.SPEED_TO_TURN_GEAR) / self.SPEED_TO_TURN_GEAR * 1500 + 1500)
        else:
            return int((self.speed % self.SPEED_TO_TURN_GEAR) / self.SPEED_TO_TURN_GEAR * 1000 + 2500)



def main():
    import time
    vp = VertexPool('map.json')
    emulator = Emulator(vp)
    start = time.time()
    while True:
        try:
            emulator.update(0.1)
            if emulator.tick % 100000 == 0:
                end = time.time()
                print("performance {:.2f} ticks per second".format(100000 / (end - start)))
                start = end
        except KeyboardInterrupt:
            print("Keyboard interrupt")
            return
        except Exception as ex:
            import traceback
            print("Unexpected exception: {}".format(ex))
            print(''.join(traceback.format_exception(None, ex, ex.__traceback__)), file=sys.stderr, flush=True)
            import pickle
            pickle.dump(emulator, open('emulator_{}.dmp'.format(random.randint(0,10000)), 'wb'))
            return


if __name__ == '__main__':
    main()

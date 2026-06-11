extends Node2D

enum Direction {
	LEFT,
	UP,
	RIGHT
}

enum Mode {
	ADDITION,
	SUBTRACTION,
	MULTIPLICATION,
	DIVISION,
	POWERS,
	SQUAREROOT
}

var game_started = true

var max_gen_number = Global	.max_gen_num

var reset_time = Global.reset_time
var times = [reset_time, reset_time]

var points = [0, 0]
var solutions = [Direction.LEFT, Direction.LEFT]

var half_screen := 0.0

var CorrectScene: PackedScene = preload("res://Scenes/Correct.tscn")
var WrongScene: PackedScene = preload("res://Scenes/Wrong.tscn")
var TimeScene: PackedScene = preload("res://Scenes/time.tscn")
var WrongSprite: PackedScene = preload("res://Scenes/WrongSprite.tscn")

@onready var players = [
	$Gui/Player1,
	$Gui/Player2
]

# Two Buttons At the Same time
var t1 := -1.0
var t2 := -1.0
var window := 0.5


func _ready() -> void:
	randomize()

	make_task(0)
	make_task(1)

	update_points(0)
	update_points(1)


func _process(delta: float) -> void:
	half_screen = get_viewport_rect().size.x / 2

	if Input.is_action_just_pressed("Reset"):
		handle_reset()
	if check_buttons():
		handle_reset()

	if is_game_over() or game_started:
		return

	handle_inputs()
	update_timers(delta)
	check_winner()


# --------------------------------------------------
# TASKS
# --------------------------------------------------

func generate_task(mode : Mode) -> Dictionary:
	var question := ""
	var correct_answer := 0

	match mode:
		0: # Addition
			var a = randi_range(0, max_gen_number)
			var b = randi_range(0, max_gen_number)
			question = "%d + %d" % [a, b]
			correct_answer = a + b

		1: # Subtraction (no negatives)
			var a = randi_range(0, max_gen_number)
			var b = randi_range(0, a)
			question = "%d - %d" % [a, b]
			correct_answer = a - b

		2: # Multiplication
			var a = randi_range(0, max_gen_number)
			var b = randi_range(0, max_gen_number)
			question = "%d * %d" % [a, b]
			correct_answer = a * b

		3: # Division (always clean integer)
			var answer = randi_range(1, max_gen_number)
			var divisor = randi_range(1, max_gen_number)
			var dividend = answer * divisor
			question = "%d / %d" % [dividend, divisor]
			correct_answer = answer

		4: # Powers (exponents)
			var base = randi_range(0, max_gen_number)
			var exponent = randi_range(0, 3)
			question = "%d ^ %d" % [base, exponent]
			correct_answer = pow(base, exponent)

		5: # Square root (perfect square)
			var answer = randi_range(0, max_gen_number)
			var square = answer * answer
			question = "√%d" % square
			correct_answer = answer


	# -----------------------------
	# Generate safe unique answers
	# -----------------------------
	var answers = [correct_answer]
	var max_offset = max(10, abs(correct_answer))

	while answers.size() < 3:
		var wrong = correct_answer + randi_range(-max_offset, max_offset)

		if wrong < 0:
			continue

		if wrong not in answers:
			answers.append(wrong)

	answers.shuffle()

	return {
		"equation": question,
		"answers": answers,
		"solution": answers.find(correct_answer)
	}


func make_task(player: int) -> void:
	times[player] = reset_time

	var task = generate_task(Global.mode)

	solutions[player] = task.solution

	players[player].get_node("eq").text = task.equation
	players[player].get_node("OptionLeft").text = str(task.answers[0])
	players[player].get_node("OptionUp").text = str(task.answers[1])
	players[player].get_node("OptionRight").text = str(task.answers[2])


# --------------------------------------------------
# ANSWERS
# --------------------------------------------------

func answer(player: int, choice: int) -> void:
	var correct = choice == solutions[player]

	if correct:
		points[player] += 1
		spawn_particle("Correct", random_player_x(player))
	else:
		if points[player] > -5: points[player] -= 1
		spawn_sprite(player, choice)

	update_points(player)
	make_task(player)


# --------------------------------------------------
# INPUT
# --------------------------------------------------

func handle_inputs() -> void:
	if Input.is_action_just_pressed("Left1"):
		answer(0, Direction.LEFT)

	if Input.is_action_just_pressed("Up1"):
		answer(0, Direction.UP)

	if Input.is_action_just_pressed("Right1"):
		answer(0, Direction.RIGHT)

	if Input.is_action_just_pressed("Left2"):
		answer(1, Direction.LEFT)

	if Input.is_action_just_pressed("Up2"):
		answer(1, Direction.UP)

	if Input.is_action_just_pressed("Right2"):
		answer(1, Direction.RIGHT)


# --------------------------------------------------
# TIMERS
# --------------------------------------------------

func update_timers(delta: float) -> void:
	for player in range(2):
		times[player] -= delta

		if times[player] < 0:
			if points[player] > -5: points[player] -= 1

			update_points(player)
			make_task(player)

			spawn_particle(
				"Time",
				random_player_x(player)
			)

		players[player].get_node("Time").text = \
			"Czas: " + str(snapped(times[player], 1))


# --------------------------------------------------
# UI
# --------------------------------------------------

func update_points(player: int) -> void:
	players[player].get_node("PointsInfo").text = \
		"Punkty: " + str(points[player])


func check_winner() -> void:
	if points[0] > 10:
		$Gui/Player1.visible = false
		$Gui/Win1.visible = true

	if points[1] > 10:
		$Gui/Player2.visible = false
		$Gui/Win2.visible = true


func is_game_over() -> bool:
	return \
		$Gui/Win1.visible or \
		$Gui/Win2.visible


func handle_reset() -> void:
	game_started = false
	
	points[0] = 0
	points[1] = 0

	$Gui/StartInfo.visible = false
	$Gui/Player1.visible = true
	$Gui/Win1.visible = false
	$Gui/Player2.visible = true
	$Gui/Win2.visible = false

	update_points(0)
	update_points(1)

	make_task(0)
	make_task(1)


# --------------------------------------------------
# PARTICLES
# --------------------------------------------------

func spawn_sprite(player, option):
	var obj = WrongSprite.instantiate()
	var x = 0
	
	if player == 0:
		if option == Direction.LEFT: x = $Gui/Player1/ArrowLeft.position.x
		if option == Direction.UP: x = $Gui/Player1/ArrowUp.position.x
		if option == Direction.RIGHT: x = $Gui/Player1/ArrowRight.position.x
	if player == 1:
		if option == Direction.LEFT: x = $Gui/Player2/ArrowLeft.position.x + 640
		if option == Direction.UP: x = $Gui/Player2/ArrowUp.position.x + 640
		if option == Direction.RIGHT: x = $Gui/Player2/ArrowRight.position.x + 640
	obj.position = Vector2(x, 520)
	obj.scale = Vector2(0.5,0.5)
	add_child(obj)

func spawn_particle(type: String, x: float) -> void:
	var obj

	match type:
		"Correct":
			obj = CorrectScene.instantiate()

		"Time":
			obj = TimeScene.instantiate()

		_:
			obj = WrongScene.instantiate()

	obj.StartPosition = Vector2(
		x,
		randi_range(0, 300)
	)

	obj.scale = Vector2(0.2, 0.2)

	add_child(obj)


func random_player_x(player: int) -> float:
	if player == 0:
		return randf_range(0, half_screen)

	return randf_range(
		half_screen,
		half_screen * 2
	)

func check_buttons() -> bool:
	var now = Time.get_ticks_msec() / 1000.0

	var triggered := false

	if Input.is_action_just_pressed("Down1"):
		t1 = now

	if Input.is_action_just_pressed("Down2"):
		t2 = now

	if t1 > 0 and t2 > 0:
		if abs(t1 - t2) <= window:
			triggered = true
			t1 = -1
			t2 = -1

	# expire old inputs (IMPORTANT)
	if t1 > 0 and now - t1 > window:
		t1 = -1

	if t2 > 0 and now - t2 > window:
		t2 = -1

	return triggered

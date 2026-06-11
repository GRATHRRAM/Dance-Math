extends Node2D

var Points1 = 0
var Points2 = 0
var Sol1 = "Left"
var Sol2 = "Left"
var Time1 = 5
var Time2 = 5

var HalfScreen = 0

var CorrectScene : PackedScene = load("res://Scenes/Correct.tscn")
var WrongScene : PackedScene = load("res://Scenes/Wrong.tscn")
var TimeScene: PackedScene = load("res://Scenes/time.tscn")

func MakeTask(Player : int) -> void:
	if Player == 1:
		Time1 = 5
		var rand1 = randi_range(0,10)
		var rand2 = randi_range(0,10)
		var Eq1 = str(rand1) + " * " + str(rand2) + " = ?"
		
		var Aws = ["99","99", "99"]
		for i in 3:
			Aws[i] = randi_range(0,10) * randi_range(0,10)
		
		var randAwSol = randi_range(0,2)
		Aws[randAwSol] = rand1 * rand2
		
		for i in 3:
			if i != randAwSol:
				if Aws[i] == rand1 * rand2:
					Aws[i] = (rand1+rand2) * rand2
					if Aws[i] > 100:
						Aws[i] = 100
		
		if randAwSol == 0: Sol1 = "Left"
		if randAwSol == 1: Sol1 = "Up"
		if randAwSol == 2: Sol1 = "Right"
		
		$Gui/Player1/eq.text = Eq1
		$Gui/Player1/OptionLeft.text = str(Aws[0])
		$Gui/Player1/OptionUp.text = str(Aws[1])
		$Gui/Player1/OptionRight.text = str(Aws[2])
	if Player == 2:
		Time2 = 5
		var rand1 = randi_range(0,10)
		var rand2 = randi_range(0,10)
		var Eq1 = str(rand1) + " * " + str(rand2) + " = ?"
		
		var Aws = ["99","99", "99"]
		for i in 3:
			Aws[i] = randi_range(0,10) * randi_range(0,10)
		
		var randAwSol = randi_range(0,2)
		Aws[randAwSol] = rand1 * rand2
		
		for i in 3:
			if i != randAwSol:
				if Aws[i] == rand1 * rand2:
					Aws[i] = (rand1+rand2) * rand2
					if Aws[i] > 100:
						Aws[i] = 100
		
		if randAwSol == 0: Sol2 = "Left"
		if randAwSol == 1: Sol2 = "Up"
		if randAwSol == 2: Sol2 = "Right"
		
		$Gui/Player2/eq.text = Eq1
		$Gui/Player2/OptionLeft.text = str(Aws[0])
		$Gui/Player2/OptionUp.text = str(Aws[1])
		$Gui/Player2/OptionRight.text = str(Aws[2])

func SpawnParticle(type, x):
	var obj = null
	if type == "Correct":
		obj = CorrectScene.instantiate()
	elif type == "Time":
		obj = TimeScene.instantiate()
	else:
		obj = WrongScene.instantiate()
	
	obj.set("StartPosition", Vector2(x, randi_range(0,300)))
	obj.scale = Vector2(0.2,0.2)
	add_child(obj)

func _ready() -> void:
	randomize()
	MakeTask(1)
	MakeTask(2)

func _process(delta: float) -> void:
	HalfScreen = get_viewport_rect().size.x / 2
	
	if Input.is_action_just_pressed("Reset"):
		Points1 = 0
		Points2 = 0
		$Gui/Player1/Win.visible = false
		$Gui/Player2/Win.visible = false
		$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
		$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
		MakeTask(1)
		MakeTask(2)
	
	if Points1 > 10:
		$Gui/Player1/Win.visible = true
	if Points2 > 10:
		$Gui/Player2/Win.visible = true
	
	if !$Gui/Player1/Win.visible and !$Gui/Player2/Win.visible:
		if Input.is_action_just_pressed("Left1"):
			if Sol1 == "Left":
				Points1 += 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Correct", randf_range(0, HalfScreen))
			else:
				Points1 -= 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Wrong", randf_range(0, HalfScreen))
		if Input.is_action_just_pressed("Up1"):
			if Sol1 == "Up":
				Points1 += 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Correct", randf_range(0, HalfScreen))
			else:
				Points1 -= 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Wrong", randf_range(0, HalfScreen))
		if Input.is_action_just_pressed("Right1"):
			if Sol1 == "Right":
				Points1 += 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Correct", randf_range(0, HalfScreen))
			else:
				Points1 -= 1
				$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
				MakeTask(1)
				SpawnParticle("Wrong", randf_range(0, HalfScreen))
		#player2
		if Input.is_action_just_pressed("Left2"):
			if Sol2 == "Left":
				Points2 += 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Correct", randf_range(HalfScreen, HalfScreen*2))
			else:
				Points2 -= 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Wrong", randf_range(HalfScreen, HalfScreen*2))
		if Input.is_action_just_pressed("Up2"):
			if Sol2 == "Up":
				Points2 += 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Correct", randf_range(HalfScreen, HalfScreen*2))
			else:
				Points2 -= 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Wrong", randf_range(HalfScreen, HalfScreen*2))
		if Input.is_action_just_pressed("Right2"):
			if Sol2 == "Right":
				Points2 += 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Correct", randf_range(HalfScreen, HalfScreen*2))
			else:
				Points2 -= 1
				$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
				MakeTask(2)
				SpawnParticle("Wrong", randf_range(HalfScreen, HalfScreen*2))
		Time1 -= delta
		Time2 -= delta
		if Time1 < 0:
			Time1 = 5
			Points1 -= 1
			$Gui/Player1/PointsInfo.text = "Punkty: " + str(Points1)
			MakeTask(1)
			SpawnParticle("Time", randf_range(0, HalfScreen))
		if Time2 < 0:
			Time2 = 5
			Points2 -= 1
			$Gui/Player2/PointsInfo.text = "Punkty: " + str(Points2)
			MakeTask(2)
			SpawnParticle("Time", randf_range(HalfScreen, HalfScreen*2))
		$Gui/Player1/Time.text = "Czas: " + str(snapped(Time1, 1))
		$Gui/Player2/Time.text = "Czas: " + str(snapped(Time2, 1))

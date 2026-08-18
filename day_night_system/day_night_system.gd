extends ColorRect

signal cycle_completed
signal midnight

@export var cycle_length := 100
@export_range(0.0, 1.0) var max_darkness := 0.5

var time := 0.0
var midnight_signalled := false

func _ready() -> void:
	color = Color(0.05, 0.05, 0.15, 0.0)

func _process(delta: float) -> void:
	time += delta

	if not midnight_signalled and time >= cycle_length/2:
		print_debug("daynightsystem")
		midnight.emit()
		midnight_signalled = true

	if time >= cycle_length:
		time = fmod(time, cycle_length)
		cycle_completed.emit()
		midnight_signalled = false

	var cycle := time / cycle_length
	var darkness := (sin(cycle * TAU - PI / 2.0) + 1.0) / 2.0
	
	color.a = darkness * max_darkness

class_name AudioSystem extends Node

static var instance: AudioSystem

# Singleton ready function
func _ready():
	instance = self


func iron():
	$Wheat.play()

func wheat():
	$Wheat.play()

func block():
	$Iron.play()

extends Node

var clicked = false
var sceneClass = load("res://Block.tscn")

func _ready():
	$Cam1.current = true

func _on_SpawnBlock_spawn(pos, type, isOperator):
	var blk = sceneClass.instance()
	blk.set_position(pos)
	blk.set_scale(Vector2(0.25,0.25))
	blk.value = type
	blk.isOperator = isOperator
	$CanvasLayer.call_deferred("add_child" , blk)
	


func _on_Button_pressed():
	$Cam2.current = true


func _on_Button2_pressed():
	$Cam1.current = true

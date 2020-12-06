extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/AnimationPlayer.play("New Anim")

var overworld = "res://Overworld2.tscn"
func _on_Enter_pressed():
	SceneChanger.change_scene(overworld)
	

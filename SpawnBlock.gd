extends Area2D

var block_snapped = false
export var type = ""
export var isOperator = false
signal spawn(type, isOperator)


func _ready():
	emit_signal("spawn", self.global_position, type, isOperator)

func _on_Area2D_area_entered(area):
	pass


func _on_Area2D_area_exited(area):
	emit_signal("spawn", self.global_position, type, isOperator)
	

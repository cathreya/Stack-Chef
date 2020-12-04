extends Area2D

var block_snapped = false
signal enter_block(me, him)
signal exit_block(me, him)

func _ready():
	$Label.text = self.name

func _on_Area2D_area_entered(area):
	emit_signal("enter_block", self, area)


func _on_Area2D_area_exited(area):
	emit_signal("exit_block", self, area)

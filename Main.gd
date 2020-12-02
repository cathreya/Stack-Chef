extends Node

var clicked = false;
var sceneClass = load("res://Block.tscn")

func _on_SpawnBlock_spawn(pos, type, isOperator):
	print("here", pos, type, isOperator)
	var blk = sceneClass.instance()
	blk.set_position(pos)
	blk.set_scale(Vector2(0.25,0.25))
	blk.value = type
	blk.isOperator = isOperator
	call_deferred("add_child" , blk)
	print(blk)
	print(self.get_children())

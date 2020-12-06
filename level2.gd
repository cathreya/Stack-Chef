extends Node

var clicked = false
var sceneClass = load("res://Block.tscn")

export var star1thresh = 0
export var star2thresh = 0
export var star3thresh = 0

signal level_complete(score, stars)


func _ready():
	$Cam1.current = true
	$CanvasLayer/chef.talk("Heya kid. Welcome to my pizzaria! We have not one, not two, but three stacks here! You'll notice that different types of pizza have the same intial steps. Here's a piece of advice, use the \"Toggle Loop\" feature to produce the common ingredients in one stack while using the others to finish up for particular orders. If you are running out of space, you can press the up arrow key to get more stack space.")

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

var EndClass = load("res://EndScreen.tscn")

func complete(score, stars):
	emit_signal("level_complete",score, stars)

func _on_OrderList_level_over(score):
	var end = EndClass.instance()
	end.score = score
	end.star1thresh = star1thresh
	end.star2thresh = star2thresh
	end.star3thresh = star3thresh
	end.level_name = "Level"
	print(self.get_children())
	add_child(end)
	end.show(score)
	end.connect("level_complete",self,"complete")
	print(self.get_children())

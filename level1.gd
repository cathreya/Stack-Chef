extends Node

var clicked = false
var sceneClass = load("res://Block.tscn")

export var star1thresh = 0
export var star2thresh = 0
export var star3thresh = 0

signal level_complete(score, stars)

var tut_stage = 0

signal fourth

var tutorial = [
	"Hi, welcome to my bakery! You will be cooking with that marvelous invention over there called the stack! To get started, try dragging an ingredient onto the stack.",
	"Great. Ingredients are marked by blue blocks, whereas actions are marked by red blocks. An action like mix takes two ingredients below it and produces a mixed ingredient. These are denoted by purple. Try mixing sugar and flour!",
	"Good job! As you can see there is a purple mixed ingredient. You would have noticed each step takes some time and after all the steps there is some cooldown time. To make a cake, lets mix this with milk and bake it in the oven. Remember, an action acts on the object below it",
	"Perfect, you are ready to serve the first customer. Customer orders are put on the clipboard to the right. There is a timer for each customer after which he will get angry and leave. Your job is to serve the customer the dish they request. Drag the cake to the order and click serve.",
	"Great job, spend the remaining time experimenting, you can always use the trash if you end up producing junk! Junk is represented by a dark grey block with a dead fish, its best you throw it away."
]

func progress_tut():
	$CanvasLayer/chef.talk(tutorial[tut_stage])
	tut_stage += 1

func _ready():
	$Cam1.current = true
	progress_tut()

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

extends Node2D

var list = []  
var OrderClass = load("res://Order.tscn")

export var possible_dishes = []
export var time_low = 0
export var time_high = 0

export var interval_low = 0
export var interval_high = 0

export var order_count = 0

signal fourth
var fdone = false

var score = 0
signal level_over(score)
func draw_score():
	$Score_Label.text = "SCORE: " + str(score)

var active = 0

func add_score(time_taken):
#	Modify scoring appropriately
	$AudioStreamPlayer.play()
	var base = 100
	var multiplier = 10
	score += base + time_taken*multiplier
	if not fdone:
		emit_signal("fourth")
		fdone = true
	draw_score()
	
func incorrect_sub_score():
	score -= 30
	draw_score()

func miss_sub_score():
#	score -= 60
	draw_score()

func put_in_list(order):
	active += 1
	for i in range(list.size()):
		if list[i] == null:
			list[i] = order
			return
	list.append(order)
	
func draw_orders():
	for i in range(list.size()):
		if list[i] == null:
			continue
		list[i].set_position(Vector2(0,400 + 600*i))
		#print(list[i].position)

func done():
	if order_count == 0 and active == 0:
		emit_signal("level_over",score)


func add_order(pitem = false):
	var order = OrderClass.instance()
	if pitem:
		order.item = pitem
	else:
		order.item = possible_dishes[randi()%possible_dishes.size()]
	order.time = time_low + randi()%(time_high-time_low)
	order.connect("correct_order", self, "add_score")
	order.connect("incorrect_order", self, "incorrect_sub_score")
	order.connect("missed_order", self, "miss_sub_score")
	order.connect("active_zero", self, "done")
	put_in_list(order)
	call_deferred("add_child", order)
	draw_orders()

export var tut = false
func _ready():
	randomize()
	if tut:
		add_order("Cake")
		order_count -= 1
	while order_count > 0:
		add_order()
		var wait_time = interval_low + randi()%(interval_high - interval_low)
		yield(get_tree().create_timer(wait_time),"timeout")
		order_count -= 1
	
	done()

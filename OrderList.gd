extends Node2D

var list = []  
var OrderClass = load("res://Order.tscn")

export var possible_dishes = []
export var time_low = 0
export var time_high = 0

export var interval_low = 0
export var interval_high = 0

export var order_count = 0

var score = 0

func draw_score():
	$Score_Label.text = "SCORE: " + str(score)

func add_score(time_taken):
#	Modify scoring appropriately
	var base = 100
	var multiplier = 10
	score += base + time_taken*multiplier
	draw_score()
	
func incorrect_sub_score():
	score -= 30
	draw_score()

func miss_sub_score():
#	score -= 60
	draw_score()

func put_in_list(order):
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

func add_order():
	var order = OrderClass.instance()
	order.item = possible_dishes[randi()%possible_dishes.size()]
	order.time = time_low + randi()%(time_high-time_low)
	order.connect("correct_order", self, "add_score")
	order.connect("incorrect_order", self, "incorrect_sub_score")
	order.connect("missed_order", self, "miss_sub_score")
	put_in_list(order)
	call_deferred("add_child", order)
	draw_orders()
	
func _ready():
	for i in range(order_count):
		add_order()
		var wait_time = interval_low + randi()%(interval_high - interval_low)
		yield(get_tree().create_timer(wait_time),"timeout")
		
	

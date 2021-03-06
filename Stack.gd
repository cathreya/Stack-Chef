extends Node2D


var stack = []  
var sceneClass = load("res://GridBlock.tscn")
var ClockClass = load("res://Clock.tscn")
var BlockClass = load("res://Block.tscn")
var base_cook_time = 5
var in_use = false

signal first
signal second
signal third


func _ready():
	$Clock.hide()
	for i in range(30):
		var scene = sceneClass.instance()
		scene.set_name(str(i))
		scene.set_position(Vector2(0,-100-200*i))
		stack.append(scene)
		add_child(scene)	
		scene.connect("enter_block", self, "snap")
		scene.connect("exit_block", self, "out")

var fdone = false
var sdone = false
var tdone = false
func snap(me,him):
	if not fdone:
		emit_signal("first")
		fdone = true

func out(me,him):
	print(me.name, me.block_snapped)

#var ops ={
#	"Mix" : {
#		"Flour":{"Sugar": "Sugar+Flour"},
#		"Sugar":{"Flour": "Sugar+Flour"},
#		"Milk":{"Sugar+Flour": "Batter"},
#		"Choco Chips":{"Batter": "Chocolate Batter"},
#		"Fruit Pulp":{"Batter": "Fruit Batter"},			
#	},
#	"Bake" : {"Batter":"Cake", "Chocolate Batter": "Chocolate+Cake", "Fruit Batter":"Fruit+Cake"},
#	"Frosting":{ "Chocolate+Cake":"Chocolate Cake", "Fruit+Cake":"Fruit Cake"},
#	"Blend": {"Fruits": "Fruit Pulp"},
#	"Chop":{"Chocolate": "Choco Chips"}
#}
var ops ={
	"Mix" : {
		"Flour":{"Sugar": "Sugar+Flour", "Salt": "Flour+Salt"},
		"Sugar":{"Flour": "Sugar+Flour"},
		"Milk":{"Sugar+Flour": "Batter"},
		"Choco Chips":{"Batter": "Chocolate Batter"},
		"Fruit Pulp":{"Batter": "Fruit Batter"},  
		"Tomato":{"Garlic": "Tomato+Garlic"},          
	},
	"Bake" : {"Batter":"Cake", "Chocolate Batter": "Chocolate+Cake", "Fruit Batter":"Fruit+Cake", "Cheese+Crust": "Cheese Pizza", "Veg+Crust": "Veg Pizza" },
	"Frosting":{ "Chocolate+Cake":"Chocolate Cake", "Fruit+Cake":"Fruit Cake" },
	"Blend": {"Fruits": "Fruit Pulp", "Tomato+Garlic": "Sauce"},
	"Chop":{"Chocolate": "Choco Chips", "Vegetables": "Veg Toppings"},
	"Knead":{
		"Flour+Salt":{"Oil": "Dough"}},
	"Grate":{"Cheese": "Grated Cheese"},
	"Garnish":{
		"Dough": {"Sauce": "Crust"},
		"Crust": {"Grated Cheese": "Cheese+Crust", "Veg Toppings": "Veg+Crust"},
	}
}

func proc2op(dict, ing1, ing2):
	if(dict.has(ing1) and dict[ing1].has(ing2)):
		return dict[ing1][ing2]
	elif (dict.has(ing2) and dict[ing2].has(ing1)):
		return dict[ing2][ing1]
	else:
		return "Junk"

func upd_bstk(bstk, val):
	if bstk.empty():
		return
	bstk[-1].block_snapped.value = val
	bstk[-1].block_snapped.update_text()

func del_bstk(bstk):
	if bstk.empty():
		return
	var tmp  = bstk.pop_back()
	tmp.block_snapped.queue_free()
	tmp.block_snapped = false

func two_var_op(st, bstk, dict):
	var ing1 = "Junk"
	var ing2 = "Junk"
	if not st.empty():
		ing1 = st.pop_back()
		del_bstk(bstk)
	else:
		return
	if not st.empty():
		ing2 = st.pop_back()
	
	var result = proc2op(dict, ing1, ing2)
	st.append(result)
	upd_bstk(bstk,result)

func one_var_op(st, bstk, dict):
	var ing1 = "Junk"
	if not st.empty():
		ing1 = st.pop_back()
	else:
		return 
	if(ing1 in dict):
		st.append(dict[ing1])
		upd_bstk(bstk, dict[ing1])
	else:
		st.append("Junk")
		upd_bstk(bstk, "Junk")

var v1op = funcref(self, "one_var_op")
var v2op = funcref(self, "two_var_op")

#var optofunc = {"Mix": v2op, "Bake": v1op, "Frosting":v1op, "Blend":v1op, "Chop":v1op }
#var opt_time = {"Mix": 2, "Bake": 3, "Frosting": 1, "Blend": 2, "Chop": 2}

var optofunc = {"Mix": v2op, "Bake": v1op, "Frosting":v1op, "Apply":v2op, "Blend":v1op, "Chop":v1op, "Knead":v2op, "Grate":v1op, "Garnish":v2op }
#var opt_time = {"Mix": 6, "Bake": 10, "Apply": 4, "Blend": 6, "Chop": 4,"Knead":7, "Grate":3, "Garnish":3 }
var opt_time = {"Mix": 2, "Bake": 3, "Frosting": 1, "Apply":3, "Blend": 2, "Chop": 2, "Knead":5, "Grate":3, "Garnish":3}
var cooldown = 2
	

var loop = false
signal process_done
func process():
	in_use = true
	var st = []
	var bstk = []
	for obj in stack:
		if obj.block_snapped:
			print(st)
			var val = obj.block_snapped.value
			if obj.block_snapped.isOperator:
				obj.block_snapped.current = true
				obj.block_snapped.update_text()
				$Clock.show()
				$Clock.start(opt_time[val])
				yield(get_tree().create_timer(opt_time[val]),"timeout")
				$Clock.hide()
				optofunc[val].call_func(st, bstk, ops[val])
				bstk.append(obj)
				del_bstk(bstk)
			else:
				st.append(val)
				bstk.append(obj)
				
	if not bstk.empty():
		bstk[-1].block_snapped.position = $Dump.global_position
		bstk[-1].block_snapped.position[1] -= randi()%20
		bstk[-1].block_snapped = false
		if st[-1] == "Sugar+Flour" and not sdone:
			emit_signal("second")
			sdone = true
		if st[-1] == "Cake" and not tdone:
			emit_signal("third")
			tdone = true
	in_use = false
	emit_signal("process_done")

func _on_Button_pressed():
	if in_use:
		return
	
#	for _i in range(2):
	while(loop):
		var copy_ref = []
		for obj in stack:
			if obj.block_snapped:
				var a = BlockClass.instance()
				a.position = obj.block_snapped.position
				a.value = obj.block_snapped.value
				a.scale = obj.block_snapped.scale
				a.isOperator = obj.block_snapped.isOperator
				copy_ref.append(a)
			else:
				copy_ref.append(false)	
		
		process()
		yield(self, "process_done")
		for i in range(stack.size()):
			if copy_ref[i]:
				get_tree().get_root().get_node("Level").add_child(copy_ref[i])
			stack[i].block_snapped = copy_ref[i]
		
	process()
	yield(self, "process_done")
	$Clock.show()
	$Clock.start(cooldown)
	yield(get_tree().create_timer(cooldown),"timeout")
	$Clock.hide()

func _on_Button2_pressed():
	loop = !loop
	$Button2.modulate = Color(0,int(loop),1)

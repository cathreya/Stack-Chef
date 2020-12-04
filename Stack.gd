extends Node2D


var stack = []  
var sceneClass = load("res://GridBlock.tscn")
var ClockClass = load("res://Clock.tscn")
var BlockClass = load("res://Block.tscn")
var base_cook_time = 5
var in_use = false

func _ready():
	$Clock.hide()
	for i in range(20):
		var scene = sceneClass.instance()
		scene.set_name(str(i))
		scene.set_position(Vector2(0,-190-240*i))
		stack.append(scene)
		add_child(scene)	
		scene.connect("enter_block", self, "snap")
		scene.connect("exit_block", self, "out")

	
func snap(me,him):
	print (me.name, me.block_snapped)

func out(me,him):
	print(me.name, me.block_snapped)

var ops ={
	"Mix" : {
		"Milk":{"Base Dry Mix": "Batter"},
		"Base Dry Mix":{"Milk": "Batter"},
		"Choco Chips":{"Batter": "Chocolate Batter"},
		"Fruit Pulp":{"Batter": "Fruit Batter"},
		"Vanilla Essence":{"Batter": "Vanilla Batter"},
		"Batter":{"Choco Chips": "Chocolate Batter","Fruit Pulp": "Fruit Batter","Vanilla Essence": "Vanilla Batter"},
		"Flour":{"Baking Powder": "Flour+Baking Powder", "Sugar": "Sugar+Flour", "Sugar+Baking Powder": "Base Dry Mix"},
		"Baking Powder":{"Flour": "Flour+Baking Powder", "Sugar": "Sugar+Baking Powder", "Sugar+Flour": "Base Dry Mix"},
		"Sugar":{"Baking Powder": "Sugar+Baking Powder", "Flour": "Sugar+Flour", "Flour+Baking Powder": "Base Dry Mix"},	
	},
	"Bake" : {"Batter":"Cake", "Chocolate Batter": "Chocolate Cake", "Fruit Batter":"Fruit Cake", "Vanilla Batter":"Vanilla Cake"},
	"Apply":{
		"Cake":{"Frosting": "Frosted Cake"},
		"Chocolate Cake":{"Frosting": "Frosted Chocolate Cake"},
		"Fruit Cake":{"Frosting": "Frosted Fruit Cake"},
		"Vanilla Cake":{"Frosting": "Frosted Vanilla Cake"},
		"Frosting":{"Cake": "Frosted Cake","Chocolate Cake": "Frosted Chocolate Cake","Fruit Cake": "Frosted Fruit Cake","Vanilla Cake": "Frosted Vanilla Cake"}
	},	
	"Blend": {"Fruits": "Fruit Pulp"},
	"Chop":{"Chocolate": "Choco Chips"}
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

var optofunc = {"Mix": v2op, "Bake": v1op, "Apply":v2op, "Blend":v1op, "Chop":v1op }
var opt_time = {"Mix": 6, "Bake": 10, "Apply": 4, "Blend": 6, "Chop": 4}

	

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
				
	in_use = false
	bstk[-1].block_snapped.position = $Dump.global_position
	bstk[-1].block_snapped.position[1] -= randi()%20
	emit_signal("process_done")

func _on_Button_pressed():
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

func _on_Button2_pressed():
	loop = !loop
	$Button2.modulate = Color(0,int(loop),1)

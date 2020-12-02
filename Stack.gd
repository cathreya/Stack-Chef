extends Node2D


var stack = []  
var sceneClass = load("res://GridBlock.tscn")
var ClockClass = load("res://Clock.tscn")
var base_cook_time = 5
var in_use = false

func _ready():
	$Clock.hide()
	for i in range(10):
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

var ops = {
	"Mix" : {
		"Milk":{"Dry Ingredients": "Batter"}, 
		"Flour":{"Baking Powder": "Flour+Baking Powder", "Sugar": "Sugar+Flour", "Sugar+Baking Powder": "Dry Ingredients"},
		"Baking Powder":{"Flour": "Flour+Baking Powder", "Sugar": "Sugar+Baking Powder", "Sugar+Flour": "Dry Ingredients"},
		"Sugar":{"Baking Powder": "Sugar+Baking Powder", "Flour": "Sugar+Flour", "Flour+Baking Powder": "Dry Ingredients"},	
	},
	"Bake" : {"Batter":"Cake"},
	"Apply":{
		"Cake":{"Frosting": "Frosted Cake"},
		"Frosting":{"Cake": "Frosted Cake"}
	}	
}

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
	
	if(dict.has(ing1) and dict[ing1].has(ing2)):
		st.append(dict[ing1][ing2])
		upd_bstk(bstk,dict[ing1][ing2])
	else:
		st.append("Junk")
		upd_bstk(bstk, "Junk")

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

var optofunc = {"Mix": v2op, "Bake": v1op, "Apply":v2op }


func _on_Button_pressed():
	in_use = true
	var st = []
	var bstk = []
	for obj in stack:
		if obj.block_snapped:
			var val = obj.block_snapped.value
			if obj.block_snapped.isOperator:
				obj.block_snapped.current = true
				obj.block_snapped.update_text()
				$Clock.show()
				$Clock.start(base_cook_time)
				yield(get_tree().create_timer(base_cook_time),"timeout")
				$Clock.hide()
				optofunc[val].call_func(st, bstk, ops[val])
				bstk.append(obj)
				del_bstk(bstk)
			else:
				st.append(val)
				bstk.append(obj)
				
	in_use = false

extends Node2D


var stack = []  
var sceneClass = load("res://GridBlock.tscn")
var ClockClass = load("res://Clock.tscn")
var base_cook_time = 2

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


func two_var_op(st, dict):
	var ing1 = "Junk"
	var ing2 = "Junk"
	if not st.empty():
		ing1 = st.pop_back()
	else:
		return
	if not st.empty():
		ing2 = st.pop_back()
	
	if(dict.has(ing1) and dict[ing1].has(ing2)):
		st.append(dict[ing1][ing2])	
	else:
		st.append("Junk")

func one_var_op(st, dict):
	var ing1 = "Junk"
	if not st.empty():
		ing1 = st.pop_back()
	if(ing1 in dict):
		st.append(dict[ing1])	
	else:
		st.append("Junk")

var v1op = funcref(self, "one_var_op")
var v2op = funcref(self, "two_var_op")

var optofunc = {"Mix": v2op, "Bake": v1op, "Apply":v2op }
func _on_Button_pressed():
	var st = []
	for obj in stack:
		if obj.block_snapped:
			var val = obj.block_snapped.value
			if obj.block_snapped.isOperator:
				optofunc[val].call_func(st, ops[val])
			else:
				st.append(val)
	
	
	$Clock.show()
	$Clock.start(base_cook_time)
	yield(get_tree().create_timer(base_cook_time),"timeout")
	$Clock.hide()
	for obj in stack:
		if obj.block_snapped:
			if not st.empty():
				obj.block_snapped.value = st.pop_front()
				obj.block_snapped.update_text()
			else:
				obj.block_snapped.queue_free()
				obj.block_snapped = false

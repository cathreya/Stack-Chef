extends Node2D


var stack = []  
var sceneClass = load("res://GridBlock.tscn")

func _ready():
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


var mixtures = {"Milk":{"Flour": "Milk+Flour"}, "Flour":{"Milk": "Milk+Flour"}}
func mix(st):
	var ing1 = "Junk"
	var ing2 = "Junk"
	if not st.empty():
		ing1 = st.pop_back()
	else:
		return
	if not st.empty():
		ing2 = st.pop_back()
	
	if(mixtures.has(ing1) and mixtures[ing1].has(ing2)):
		st.append(mixtures[ing1][ing2])	
	else:
		st.append("Junk")

var optofunc = {"Mix": funcref(self,"mix")}
func _on_Button_pressed():
	var st = []
	for obj in stack:
		if obj.block_snapped:
			if obj.block_snapped.isOperator:
				optofunc[obj.block_snapped.value].call_func(st)
			else:
				st.append(obj.block_snapped.value)
	
	for obj in stack:
		if obj.block_snapped:
			if not st.empty():
				obj.block_snapped.value = st.pop_front()
				obj.block_snapped.update_text()
			else:
				obj.block_snapped.queue_free()
				obj.block_snapped = false

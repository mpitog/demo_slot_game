extends Control

var balance : float = 1000.0
var spin_cost : float = 5
var min_spin : float = 5
var max_spin : float = 20
@onready var label_balance: Label = $Label_balance
@onready var label_spin: Label = $Label_spin
@onready var button: Button = $Button
@onready var cpu_particles_2d: CPUParticles2D = $"../CPUParticles2D"
@onready var cpu_particles_2d_2: CPUParticles2D = $"../CPUParticles2D2"
@onready var label: Label = $"../Label"
@onready var button_ok: Button = $"../Button_ok"

var rounds_played : int = 0


# Define the symbols that can appear in the slots
var symbol_data = {
	"bell" : {"texture": preload("res://bell.png"), "value": 15.0},
	"cheries" :{"texture" : preload("res://cherries.png"), "value": 5.0},
	"seven" : {"texture" : preload("res://seven.png"), "value": 50.0},
	"watermelon" : {"texture": preload("res://watermelon.png"), "value": 10.0}
}
# Slots references
var slots = []
var slot_values = []
var won = false

func _process(_delta: float) -> void:
	define_label_balance()
	define_label_spin_cost()
	if balance < spin_cost:
		button.disabled = true
	elif balance >= spin_cost:
		button.disabled = false
		
func _ready():
	for i in range($GridContainer.columns*3):
		var slot = $GridContainer.get_child(i)
		slots.append(slot)
		slot_values.append(null)

func spin():
	won = false
	# Randomize each slot with a symbol
	for i in range(slots.size()):
		var random_symbol_key = symbol_data.keys()[randi() % symbol_data.size()]
		var symbol_info = symbol_data[random_symbol_key]
		slots[i].texture = symbol_info.texture
		slot_values[i] = symbol_info.value
		#print(slot_values[i])
	 # After spinning, check for identical symbols in rows
	check_rows_for_identical_symbols()
	rounds_played += 1
	#print(rounds_played)


func _on_button_pressed() -> void:
	spin()
	balance -=spin_cost


func define_label_balance() -> void:
	label_balance.text = ("Balance: " + str(balance))
	
func define_label_spin_cost() -> void:
	label_spin.text = ("Spin Cost: " + str(spin_cost))

func _on_plus_pressed() -> void:
	if spin_cost < max_spin:
		spin_cost += 5

func _on_minus_pressed() -> void:
	if spin_cost > min_spin:
		spin_cost -= 5
		

func check_row(slot1_index, slot2_index, slot3_index, slot4_index) -> bool:
	var texture1 = slots[slot1_index].texture
	var texture2 = slots[slot2_index].texture
	var texture3 = slots[slot3_index].texture
	var texture4 = slots[slot4_index].texture

	if texture1 == texture2 and texture2 == texture3 and texture3 == texture4:
		return true
		
		#if won == true:
			#var bell = preload("res://bell.png")
			#var cherries = preload("res://cherries.png")
			#var seven = preload("res://seven.png")
			#var watermelon = preload("res://watermelon.png")
			#if texture1 == bell:
				#var bell_value = symbol_data["bell"]["value"]
				#balance += spin_cost * bell_value
				#print("works")
			#elif texture1 == cherries:
				#var cherries_value = symbol_data["cherries"]["value"]
				#balance += spin_cost * cherries_value
				#print("works")
			#elif texture1 == seven:
				#var seven_value = symbol_data["seven"]["value"]
				#balance += spin_cost * seven_value
				#print("works")
			#elif texture1 == watermelon:
				#var watermelon_value = symbol_data["watermelon"]["value"]
				#balance += spin_cost * watermelon_value
				#print("works")
	else:
		return false
	
# Function to check if any row has identical symbols
func check_rows_for_identical_symbols():
	var row1_identical = check_row(0, 1, 2, 3 )
	if row1_identical:
		won = true
		get_symbol_value(0)
		print("Row 1 has identical symbols!")
	var row2_identical = check_row(4, 5, 6, 7)
	if row2_identical:
		won = true
		get_symbol_value(4)
		print("Row 2 has identical symbols!")
	var row3_identical = check_row(8, 9, 10, 11)
	if row3_identical:
		won = true
		get_symbol_value(8)
		print("Row 3 has identical symbols!")

func get_symbol_value(position1):
	var value_slot = slot_values[position1]
	var win_amount = value_slot * spin_cost * 5
	balance += win_amount
	if win_amount > spin_cost * 15:
		cpu_particles_2d.visible = true
		cpu_particles_2d_2.visible = true
		cpu_particles_2d.emitting = true
		cpu_particles_2d_2.emitting = true
		label.visible = true
		button_ok.visible = true
		get_tree().paused = true
	print(value_slot)
	print(balance)


func _on_button_ok_pressed() -> void:
	get_tree().paused = false
	label.visible = false
	cpu_particles_2d.visible = false
	cpu_particles_2d_2.visible = false
	button_ok.visible = false

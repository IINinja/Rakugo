extends Timer
class_name RenTimer

export var var_name : = "some_var"

export var default : = 1.0 setget set_default, get_default

func set_default(value : float) -> void:
	default = value
	wait_time = default

func get_default() -> float:
	return default

func _ready() -> void:
	if var_name in Ren.variables:
		wait_time = float(Ren.get_value(var_name))
	
	else:
		Ren.define(var_name, default)
	
	Ren.connect_var(var_name, "value_changed", self, "on_value_changed")

func on_value_changed(new_value : float) -> void:
	if new_value == 0:
		new_value = 0.1
		
	wait_time = new_value



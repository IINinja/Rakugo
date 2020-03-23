tool
extends Node
class_name RakugoAvatar, "res://addons/Rakugo/icons/rakugo_avatar.svg"

signal on_substate(substate)

onready var rnode := RakugoNodeCore.new()

export var avatar_id: String = name setget _set_avatar_id, _get_avatar_id
export var saveable := true setget _set_saveable, _get_saveable
export (Array, String) var state: Array setget _set_state, _get_state

var _avatar_id := ""
var _saveable := true
var _state := []
var avatar_link: Avatar

func _ready():
	_set_saveable(_saveable)

	if Engine.editor_hint:
		if avatar_id.empty():
			avatar_id = name
		return

	Rakugo.connect("show", self, "_on_show")
	rnode.connect("on_substate", self, "_on_substate")

	if avatar_id.empty():
		avatar_id = name

	avatar_link = Rakugo.get_avatar_link(avatar_id)

	if not avatar_link:
		avatar_link = Rakugo.avatar_link(avatar_id, get_path())

	else:
		avatar_link.node_path = get_path()

	add_to_group("save", true)

	var node_link = Rakugo.get_node_link(avatar_id)

	if node_link:
		if "state" in node_link.value:
			_set_state(node_link.value.state)


func _on_rnode_substate(substate):
	emit_signal("on_substate", substate)


func _set_avatar_id(value: String):
	_avatar_id = value


func _get_avatar_id() -> String:
	if _avatar_id == "":
		_avatar_id = name

	return _avatar_id


func _set_saveable(value: bool):
	_saveable = value

	if _saveable:
		add_to_group("save", true)

	elif is_in_group("save"):
		remove_from_group("save")

	if Engine.editor_hint:
		return

	if is_in_group("save"):
		Rakugo.debug([name, "added to save"])


func _get_saveable() -> bool:
	return _saveable


func _on_show(avatar_id: String, state_value: Array, show_args: Dictionary) -> void:
	if self.avatar_id != avatar_id:
		return

	_set_state(state_value)


func _set_state(value: Array) -> void:
	_state = value

	if not value:
		return

	if not rnode:
		return

	if not Engine.editor_hint:
		_state = rnode.setup_state(value)


func _get_state() -> Array:
	return _state


func _exit_tree() -> void:
	if Engine.editor_hint:
		return

	var id = Avatar.new("").var_prefix + avatar_id
	Rakugo.variables.erase(id)


func on_save() -> void:
	avatar_link.value["state"] = _state


func on_load(game_version: String) -> void:
	_state = avatar_link.value["state"]
	_on_show(avatar_id, _state , {})


func _on_substate(substate):
	pass

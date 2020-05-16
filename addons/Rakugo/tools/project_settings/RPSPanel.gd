tool
extends Panel

func _ready() -> void:
	$VBoxContainer/Label.hide()
	
	for box in $VBoxContainer.get_children():
		if box.name != "Label":
			box.rps = $RakugoProjectSettings
	
	connect("about_to_show", self, "load_settings")
	connect("confirmed", self, "save")


func load_settings() -> void:
	$VBoxContainer/OverBox.load_setting()
	notify("Loaded");


func save() -> void:
	$VBoxContainer/OverBox.save_setting()


func notify(text:String) -> void:
	$VBoxContainer/Label.text = text
	var scolor = Color(0, 0, 0, 0)
	$VBoxContainer/Label.show()
	
	$Tween.interpolate_property(
		$VBoxContainer/Label, "modulate",
		scolor, Color.green,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN)
	
	$Tween.interpolate_property(
		$VBoxContainer/Label, "modulate",
		Color.green, scolor,
		1, Tween.TRANS_LINEAR,Tween.EASE_IN, 0.7)
	
	$Tween.start()

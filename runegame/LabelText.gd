class_name LabelText

extends Resource 
@onready var symbol_to_index = $game_scene/symbol_to_index 

@export var LabelOne: String = "new": 
	set(value):
		LabelOne = value 
		RuneDrawn.emit(LabelOne)

@export var LabelOne: String = "new": 
	set(value):
		LabelOne = value 
		RuneDrawn.emit(LabelOne)


signal RuneDrawn(new_label)

extends Node

# Deck of cards as an array
var deck = []
var drawn_cards = []
var symbol_to_index = {
	"FEHU": 0,
	"URUZ": 1,
	"THURISAZ": 2,
	"ANSUZ": 3,
	"RAIDHO": 4,
	"KENNAZ": 5,
	"GEBO": 6,
	"WUNJO": 7,
	"HAGALAZ": 8,
	"NAUTHIZ": 9,
	"ISA": 10,
	"JERA": 11,
	"EIHWAZ": 12,
	"PERTHRO": 13,
	"ALGIZ": 14,
	"SOWILO": 15,
	"TIWAZ": 16,
	"BERKANA": 17,
	"EHWAZ": 18,
	"MANNAZ": 19,
	"LAGUZ": 20,
	"INGUZ": 21,
	"OTHALA": 22,
	"DAGAZ": 23
}
var index_to_symbol = {}

@onready var card_sprite = $CardBack
@onready var card_sprite2 = $CardBack2
@onready var card_sprite3 = $CardBack3

var current_frame = 1 

# Reference to buttons
@onready var draw_one_button = $VBoxContainer/Button
@onready var draw_three_button = $VBoxContainer/Button2

@onready var oneLabel: Label =  $HBoxContainer/OneValue
@onready var twoLabel: Label = $HBoxContainer/TwoValue
@onready var threeLabel: Label = $HBoxContainer/ThreeValue

# Reference to the card display container
@onready var card_container = $CardContainer

# Preload the Card scene
var card_scene: PackedScene = preload("res://Card.tscn")

# Preload the card front and sprite sheet
var card_sprite_sheet = preload("res://RuneSheet_line.png")

const SPRITE_SHEET_COLUMNS = 24 
const SPRITE_SHEET_ROWS = 1 
const SPRITE_SHEET_WIDTH = 384
const SPRITE_SHEET_HEIGHT = 16
const FRAME_COUNT = 2

func _ready():
	deck = range(0, 24)
	deck.shuffle()
	# Build the index_to_symbol dictionary
	for key in symbol_to_index.keys():
		index_to_symbol[symbol_to_index[key]] = key
	
func draw_card(order: int) -> void:
	if deck.size() > 0:
		var card_index = deck.pop_front()
		drawn_cards.append(card_index)
		display_card(card_index, order)
	else:
		print("Deck is empty!")

# Draw a specified number of cards from the deck
func draw_cards(count: int) -> void:
	clear_cards()
	for i in range(count):
		draw_card(i)

# Clear all existing cards from the card container
func clear_cards() -> void:
	for child in card_container.get_children():
		child.hide()

# Button press handlers
func _on_draw_one_pressed():
	current_frame = (0) % FRAME_COUNT
	card_sprite.frame = current_frame
	draw_cards(1)

func _on_draw_three_pressed():
	current_frame = (0) % FRAME_COUNT
	card_sprite.frame = current_frame
	current_frame = (0) % FRAME_COUNT
	card_sprite2.frame = current_frame
	current_frame = (0) % FRAME_COUNT
	card_sprite3.frame = current_frame
	draw_cards(3)

func _on_button_pressed():
	twoLabel.text = "Rune"
	threeLabel.text = "Rune"
	card_sprite2.frame = 1
	card_sprite3.frame = 1
	_on_draw_one_pressed()

func _on_button_2_pressed():
	_on_draw_three_pressed()

func display_card(card_index: int, order: int) -> void:
	var card_node = card_scene.instantiate()  # Instantiate the Card scene
	var card_face_sprite = card_node.get_node("Card") as Sprite2D
	var card_front_sprite = card_node.get_node("Sprite") as Sprite2D
	
	if card_face_sprite:
		card_face_sprite.texture = card_sprite_sheet
		card_face_sprite.region_enabled = true
		card_face_sprite.region_rect = calculate_region_rect(card_index)
		card_face_sprite.visible = true
		card_face_sprite.scale = card_front_sprite.scale
		
		# Center CardFaceSprite on CardFrontSprite
		card_face_sprite.position = card_front_sprite.position
		
		print("Card Face Sprite Texture:", card_face_sprite.texture)
		print("Card Face Sprite Region Rect:", card_face_sprite.region_rect)
		print("Card Face Sprite Position:", card_face_sprite.position)
	
	# Add the card node to the card container
	print("Adding Card Node to Card Container")
	card_container.add_child(card_node)
	
	# Set the text label based on the card index
	var rune_name = index_to_symbol.get(card_index, "Unknown")
	if order == 0:
		oneLabel.text = rune_name
	elif order == 1:
		twoLabel.text = rune_name
	elif order == 2:
		threeLabel.text = rune_name
	
	# Calculate and set the position of the card node
	var x_position = 0 + (order * 118)
	var y_position = 0
	card_node.position = Vector2(x_position, y_position)
	
	#card_face_sprite.z_index = 1  # Ensure CardFaceSprite is in front
	card_front_sprite.z_index = 0  # Ensure CardFrontSprite is behind




func calculate_region_rect(card_index: int) -> Rect2:
	var row = card_index / SPRITE_SHEET_COLUMNS
	var col = card_index % SPRITE_SHEET_COLUMNS
	var sprite_width = SPRITE_SHEET_WIDTH / SPRITE_SHEET_COLUMNS
	var sprite_height = SPRITE_SHEET_HEIGHT / SPRITE_SHEET_ROWS
	var rect = Rect2(col * sprite_width, row * sprite_height, sprite_width, sprite_height)
	
	print("Card Index:", card_index)
	print("Row:", row, " Column:", col)
	print("Sprite Width:", sprite_width, " Sprite Height:", sprite_height)
	print("Region Rect:", rect)
	
	return rect
	
func _on_button_3_pressed():
	deck = range(0, 24)
	deck.shuffle()
	print("Deck reset")
	print("------------------")
 # Remove all children from CardContainer
	for child in card_container.get_children():
		child.queue_free()
	print("CardContainer children removed")
	# Set the text label based on the card index
	oneLabel.text = "Rune"
	twoLabel.text = "Rune"
	threeLabel.text = "Rune"
	card_sprite.frame = 1
	card_sprite2.frame = 1
	card_sprite3.frame = 1


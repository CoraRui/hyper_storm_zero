extends Node2D
class_name store_ui


#TODO: selected item icons, vending machine, idk what else. 
#TODO: make decorative items to go in the vending machine

@export var coins_label : Label
@export var desc_label : Label
@export var price_label : Label
@export var have_label : Label
@export var overshield_desc : String = "adds another layer of overshield. you can take one more hit before being destroyed in battle."
@export var overshield_price : int = 20
@export var powerbomb_desc : String = "press z to clear all enemies on the screen. kaboom!"
@export var powerbomb_price : int = 15
@export var laseroption_desc : String = "a robot buddy to shoot more lasers. follows your ship"
@export var laseroption_price : int = 25
@export var dog_desc : String = "a solid gold dog statue. :P side effects include barking"
@export var right_scene : scene_link
@export var too_poor_sf : sf_link
@export var shield_sf : sf_link
@export var powerbomb_sf : sf_link
@export var option_sf : sf_link
@export var dog_sf : sf_link
@export var dog_price : int = 999
@export var store_tutorial : Label

@onready var scene_mi : scene_manager = get_node("/root/scene_manager_auto")
@onready var save_mi : save_manager = get_node("/root/save_manager_auto")
@onready var sfx_mi : sfx_player = get_node("/root/sfx_player_auto")


func _ready():
	update_coins()
	if save_mi.file_01.day == 0:
		store_tutorial.set_visible(true)
		

func update_coins() -> void:
	#grab the value from the file and put it in the coins label. use whenever you 
	#spend coins
	coins_label.text = str(save_mi.file_01.coins) + "G"
	

func _on_right_option_activated():
	scene_mi.load_scene(right_scene)
	
func _on_overshield_option_activated():
	#purchases another overshield option
	if save_mi.file_01.coins < overshield_price:
		sfx_mi.play_effect(too_poor_sf)
		return
	#remove coins from file
	save_mi.file_01.coins -= overshield_price
	#update the coins label
	update_coins()
	#add shield block to the spare dict
	save_mi.file_01.spare_dict["shield_block"] += 1
	#play purchased sound effect
	sfx_mi.play_effect(shield_sf)
	#update have label with number of shield blocks
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["shield_block"])

func _on_overshield_option_selected():
	#display the overshield text
	desc_label.text = overshield_desc
	price_label.text = str(overshield_price) + "G"
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["shield_block"])

func _on_powerbomb_option_activated():
	#purchases another overshield option
	if save_mi.file_01.coins < powerbomb_price:
		sfx_mi.play_effect(too_poor_sf)
		return
	#remove coins from file
	save_mi.file_01.coins -= powerbomb_price
	#update the coins label
	update_coins()
	#add shield block to the spare dict
	save_mi.file_01.spare_dict["power_block"] += 1
	#update have label with number of shield blocks
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["power_block"])
	#play purchased sound effect
	sfx_mi.play_effect(powerbomb_sf)

func _on_powerbomb_option_selected():
	desc_label.text = powerbomb_desc
	price_label.text = str(powerbomb_price) + "G"
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["power_block"])

func _on_laser_option_option_activated():
	#purchases another overshield option
	if save_mi.file_01.coins < laseroption_price:
		sfx_mi.play_effect(too_poor_sf)
		return
	#remove coins from file
	save_mi.file_01.coins -= laseroption_price
	#update the coins label
	update_coins()
	#add shield block to the spare dict
	save_mi.file_01.spare_dict["laser_block"] += 1
	#update have label with number of shield blocks
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["laser_block"])
	#play purchased sound effect
	sfx_mi.play_effect(option_sf)

func _on_laser_option_option_selected():
	desc_label.text = laseroption_desc
	price_label.text = str(laseroption_price) + "G"
	have_label.text = "INV:" + str(save_mi.file_01.spare_dict["laser_block"])

func _on_right_option_selected():
	price_label.text = "---"
	desc_label.text = "---"
	have_label.text = "---"

func _on_gold_dog_option_activated():
	#purchases another overshield option
	if save_mi.file_01.coins < dog_price:
		sfx_mi.play_effect(too_poor_sf)
		return
	#remove coins from file
	save_mi.file_01.coins -= dog_price
	#update the coins label
	update_coins()
	#add shield block to the spare dict
	save_mi.file_01.dog_statue += 1
	#update have label with number of shield blocks
	have_label.text = "INV:" + str(save_mi.file_01.dog_statue)
	#play purchased sound effect
	sfx_mi.play_effect(dog_sf)


func _on_gold_dog_option_selected():
	desc_label.text = dog_desc
	price_label.text = str(dog_price) + "G"
	have_label.text = "INV:" + str(save_mi.file_01.dog_statue)

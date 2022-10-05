extends Resource

var speed_up: bool = false
var reload_up: bool = false
var double_shot: bool = false
var explosive_shot: bool = false
var reload_halved: bool = false
var shot_speed_up: bool = false
var ammo_up_three: bool = false
var higher_damage: bool = false
var piercing_once: bool = false

var player
func pickup():
	if speed_up:
		player.speed *= 1.25
	elif reload_up:
		player.reload_timer -= 20
	elif double_shot:
		player.shot_count += 1
	elif reload_halved:
		player.reload_timer = round(player.reload_timer/2)
	elif shot_speed_up:
		player.shot_timer = max(0, player.shot_timer - 2)
	elif ammo_up_three:
		player.ammo_max += 3
		player.ammo += 3
	elif higher_damage:
		player.damage += 5
	elif piercing_once:
		player.pierce_count += 1

func get_sprite() -> String:
	if speed_up:
		return ("res://Sprites/Icons/speed_up.png")
	elif reload_up:
		return ("res://Sprites/Icons/reload_up.png")
	elif double_shot:
		return ("res://Sprites/Icons/double_shot.png")
	elif explosive_shot:
		return ("res://Sprites/Icons/explosive_shot.png")
	elif reload_halved:
		return ("res://Sprites/Icons/reload_halved.png")
	elif shot_speed_up:
		return ("res://Sprites/Icons/shot_speed_up.png")
	elif ammo_up_three:
		return ("res://Sprites/Icons/ammo_up_three.png")
	elif higher_damage:
		return ("res://Sprites/Icons/higher_damage.png")
	elif piercing_once:
		return ("res://Sprites/Icons/piercing_once.png")
	return ""

func get_name() -> String:
	if speed_up:
		return "Speed up"
	elif reload_up:
		return "Shorter reload speed"
	elif double_shot:
		return "Shoot an additional projectile"
	elif explosive_shot:
		return "Bullets explode upon impact"
	elif reload_halved:
		return "Reload time halved"
	elif shot_speed_up:
		return "Shorter time between shots"
	elif ammo_up_three:
		return "Increase max ammo by three"
	elif higher_damage:
		return "Increase damage"
	elif piercing_once:
		return "Bullets pierce one additional enemy"
	return ""

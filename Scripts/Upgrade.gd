extends Resource

var speed_up: bool = false
var reload_up: bool = false
var richochet_twice: bool = false
var double_shot: bool = false
var explosive_shot: bool = false
var exploding_kills: bool = false
var reload_halved: bool = false
var shot_speed_up: bool = false
var ammo_up_three: bool = false
var higher_damage: bool = false
var piercing_once: bool = false

var player
func pickup():
	if speed_up:
		print("picking up: speed up")
		player.speed *= 1.25
	elif reload_up:
		print("picking up: reload up")
		player.reload_timer -= 20
	elif richochet_twice:
		print("picking up: ricochet twice")
		pass
	elif double_shot:
		print("picking up: double shot")
		pass
	elif explosive_shot:
		print("picking up: exploding shot")
		pass
	elif exploding_kills:
		print("picking up: exploding kills")
		pass
	elif reload_halved:
		print("picking up: realod half")
		player.reload_timer = round(player.reload_timer/2)
	elif shot_speed_up:
		print("picking up: shot speed up")
		player.shot_timer -= 2
	elif ammo_up_three:
		print("picking up: ammo up")
		player.ammo_max += 3
		player.ammo += 3
	elif higher_damage:
		print("picking up: damage up")
		player.damage += 5
	elif piercing_once:
		print("picking up: piercing")
		pass

func drop():
	if speed_up:
		print("dropping: speed up")
		player.speed /= 1.25
	elif reload_up:
		print("dropping: reload up")
		player.reload_timer += 20
	elif richochet_twice:
		print("dropping: ricochet twice")
		pass
	elif double_shot:
		print("dropping: double shot")
		pass
	elif explosive_shot:
		print("dropping: exploding shot")
		pass
	elif exploding_kills:
		print("dropping: exploding kills")
		pass
	elif reload_halved:
		print("dropping: reload half")
		player.reload_timer = player.reload_timer*2
	elif shot_speed_up:
		print("dropping: shot speed up")
		player.shot_timer += 2
	elif ammo_up_three:
		print("dropping: ammo up")
		player.ammo_max -= 3
	elif higher_damage:
		print("dropping: damage up")
		player.damage -= 5
	elif piercing_once:
		print("dropping: piercing")
		pass

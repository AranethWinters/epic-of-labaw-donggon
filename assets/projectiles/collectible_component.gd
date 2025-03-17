extends Area2D

class_name CollectibleComponent

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox" and area.get_parent() is Player:
		var player = area.get_parent()
		do_this(player)
		get_parent().queue_free()
		
		
func do_this(player):
	pass
		

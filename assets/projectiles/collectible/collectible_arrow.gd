extends CollectibleComponent


func do_this(player):
	player.arrows += 1
	print(player.name + " collected " + str(player.arrows)+ "coin") 
	

extends Label
var table = [0, 100, 200, 300, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 125000, 250000, 500000, 1000000]
var index = 0
var money = table[index]


func update_money():
	index = index + 1
	money = table[index]
	text = str(money) + ' Br'

func set_money(mon):
	money = mon
	text = str(money) + ' Br'

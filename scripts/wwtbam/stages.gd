extends Node2D
var sec = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16] 
var green = '00ff0f'
var yellow = 'FFFF00'
var red = 'ff0000'
var current = '0000ff'
var colours = [0, 
green,  green,  green,  green,  green,
yellow, yellow, yellow, yellow, yellow,
red,    red,    red,    red,    red
]

func _ready():
	sec[0] = 0
	sec[1] = get_node('Sec1/subsec1')
	sec[2] = get_node('Sec1/subsec2')
	sec[3] = get_node('Sec1/subsec3')
	sec[4] = get_node('Sec1/subsec4')
	sec[5] = get_node('Sec1/subsec5')
	sec[6] = get_node('Sec2/subsec1')
	sec[7] = get_node('Sec2/subsec2')
	sec[8] = get_node('Sec2/subsec3')
	sec[9] = get_node('Sec2/subsec4')
	sec[10] = get_node('Sec2/subsec5')
	sec[11] = get_node('Sec3/subsec1')
	sec[12] = get_node('Sec3/subsec2')
	sec[13] = get_node('Sec3/subsec3')
	sec[14] = get_node('Sec3/subsec4')
	sec[15] = get_node('Sec3/subsec5')
	sec[16] = get_node('Sec3/subsec5')

func update_colours(secs):
	for i in range(1, secs):
		sec[i].self_modulate = colours[i]
	sec[secs].self_modulate = current

extends Node2D
var questions = 0
var answers_arr
var correct_answer
var difficulty

var current_stage 

var record

var answ_pos = [Vector2(283.75, 477.5), Vector2(860.75, 477.5), Vector2(284, 362.5), Vector2(860.75, 360.5)]

func _ready() -> void:
	questions = load_questions("res://questions/questions_extended.res")
	current_stage = 1
	difficulty = 1
	change_question(questions, 1)
	get_node('Progress bar').update_colours(current_stage)

func load_questions(file_path: String) -> Array:
	var questions_array = []  
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file: ", file_path)
		return []
	var file_content = file.get_as_text()
	file.close()
	var lines = file_content.split("\n", false)  # "false" to skip empty lines
	for i in range(0, lines.size(), 6):
		if i + 5 >= lines.size():
			break 
		var question_data = [
			lines[i].strip_edges().split(' '),      # Difficulty
			lines[i + 1].strip_edges(),  # Question
			lines[i + 2].strip_edges(),  # Correct answer
			lines[i + 3].strip_edges(),  # Wrong answer 1
			lines[i + 4].strip_edges(),  # Wrong answer 2
			lines[i + 5].strip_edges()   # Wrong answer 3
		]
		questions_array.append(question_data)
	return questions_array


func change_question(questions, difficulty):
	if questions:
		randomize()
		var q = questions.pick_random()
		if not q[0][1] == str(difficulty):
			change_question(questions, difficulty)
			return
		questions.erase(q)
		get_node("Question/Question label").text = q[1]
		if q[1].length() < 70: 
			get_node("Question/Question label").set("theme_override_font_sizes/font_size", 50)
		elif(q[1].length() < 130):
			get_node("Question/Question label").set("theme_override_font_sizes/font_size", 40)
		elif(q[1].length() < 170):
			get_node("Question/Question label").set("theme_override_font_sizes/font_size", 30)
		else:
			get_node("Question/Question label").set("theme_override_font_sizes/font_size", 24)
		answers_arr = [q[2], q[3], q[4], q[5]]
		answers_arr.shuffle()
		correct_answer = answers_arr.find(q[2])
		get_node("Answers/option1/Label").text = answers_arr[0]
		get_node("Answers/option2/Label").text = answers_arr[1]
		get_node("Answers/option3/Label").text = answers_arr[2]
		get_node("Answers/option4/Label").text = answers_arr[3]
		 
		var answer_sizings = [[12, 50], [20, 44], [33, 36], [40, 32], [50, 24], [90000, 18]]
		var objects = [get_node("Answers/option1/Label"), get_node("Answers/option2/Label"), get_node("Answers/option3/Label"), get_node("Answers/option4/Label")]
		var answer_font_size = answer_sizings[0][1]
		for item in objects:
			var i = 0
			while answer_sizings[i][0] < item.text.length():
				i = i + 1
			if answer_font_size > answer_sizings[i][1]:
				answer_font_size = answer_sizings[i][1]
				
		for item in objects:
			item.set("theme_override_font_sizes/font_size", answer_font_size)
		
		get_node('Answers/White').position = Vector2(0, -10000)
	else:
		return


func _on_option_1_button_up() -> void:
	get_node('AnimationPlayer').play('option1choice')
	get_node('Answers/White').z_index = 1
	get_node('Answers/White').position = Vector2(283.75, 477.5)
	disable_buttons()
	await get_tree().create_timer(2.0).timeout
	is_answer_right(0)


func _on_option_2_button_up() -> void:
	get_node('AnimationPlayer').play('option1choice')
	get_node('Answers/White').z_index = 1
	get_node('Answers/White').position = Vector2(860.75, 477.5)
	disable_buttons()
	await get_tree().create_timer(2.0).timeout
	is_answer_right(1)


func _on_option_3_button_up() -> void:
	get_node('AnimationPlayer').play('option1choice')
	get_node('Answers/White').z_index = 1
	get_node('Answers/White').position = Vector2(284, 362.5)
	disable_buttons()
	await get_tree().create_timer(2.0).timeout
	is_answer_right(2)


func _on_option_4_button_up() -> void:
	get_node('AnimationPlayer').play('option1choice')
	get_node('Answers/White').z_index = 1
	get_node('Answers/White').position = Vector2(861, 360.75)
	disable_buttons()
	await get_tree().create_timer(2.0).timeout
	is_answer_right(3)

func next_stage():
	current_stage += 1
	if current_stage == 6 or current_stage == 11:
		difficulty += 1
	if current_stage > 15:
		end_game()
	get_node('Progress bar').update_colours(current_stage)

func is_answer_right(option_id):
	if option_id == correct_answer:
		get_node('Answers/White').self_modulate = '#87c2329b'
		get_node('sounds/right').playing = true
		await get_tree().create_timer(1.5).timeout
		get_node('Money/amount').update_money()
		next_stage()
		change_question(questions, difficulty)
		reset()
	else:
		get_node('Answers/White').self_modulate = '#AF1B3Fa2'
		get_node('sounds/wrong').playing = true
		await get_tree().create_timer(1).timeout
		get_node('Answers/White2').position = answ_pos[correct_answer]
		get_node('Answers/White2').self_modulate = '#0aff00a2'
		var objects = [get_node("Answers/option1/Label"), get_node("Answers/option2/Label"), get_node("Answers/option3/Label"), get_node("Answers/option4/Label")]
		await get_tree().create_timer(4).timeout
		get_node('Answers/White2').position = Vector2(-1000, -1000)
		get_node("Money/amount").set_money(on_death_money(get_node("Money/amount").money)) #updating money if we lost
		end_game()

func reset():
	get_node('Answers/White').position = Vector2(0, -10000)
	get_node('sounds/background sound').playing = true
	enable_buttons()


func disable_buttons():
		get_node("Answers/option1").disabled = true
		get_node("Answers/option2").disabled = true
		get_node("Answers/option3").disabled = true
		get_node("Answers/option4").disabled = true
		get_node("Money/take money").disabled = true

func enable_buttons():
		get_node("Answers/option1").disabled = false
		get_node("Answers/option2").disabled = false
		get_node("Answers/option3").disabled = false
		get_node("Answers/option4").disabled = false
		get_node("Money/take money").disabled = false


var end_game_var = true
func _on_take_money_button_up() -> void:
	end_game_var = false
	end_game()
	

func on_death_money(current_money):
	var var_for_money = current_money
	var table = [0, 1000, 3200]
	var i = table.size() - 1
	while (current_money < table[i]):
		i-=1
		var_for_money = table[i]
	return var_for_money



func reset_end_game():
	get_node("EndGame/Bad").visible = false
	get_node("EndGame/Good").visible = false
	get_node("EndGame/Best").visible = false
	
func end_game():
	reset_end_game()
	if current_stage < 6 and current_stage > 0 and end_game_var:
		get_node("EndGame/Bad").visible = true
	elif current_stage > 15:
		get_node("EndGame/Best").visible = true
	else:
		get_node("EndGame/Good").visible = true
	get_node("Camera2D").position.x = -1175
	get_node("EndGame/Good/endgame/end_screen/end_label").text = "Поздравляем вас с окончанием игры. \n \n Ваш выигрыш: " + str(get_node("Money/amount").money) + " Br \n Ваш рекорд: " + str(max_score_check(get_node("Money/amount").money)) + " Br" + "\n \n Берегите окружающую среду!!!"
	get_node("Money/amount").money = 1
	end_game_var = true

func max_score_check(score):
	var file
	#Создаем файл если его нет
	if not FileAccess.file_exists("user://save_score.dat"):
		file = FileAccess.open("user://save_score.dat", FileAccess.WRITE)
		file.store_string("0")
		file.close()
	#Читаем 
	file = FileAccess.open("user://save_score.dat", FileAccess.READ)
	var content = int(file.get_as_text())
	file.close()
	#если побили рекорд - перезаписываем
	if score > content:
		file = FileAccess.open("user://save_score.dat", FileAccess.WRITE)
		file.store_string(str(score))
		file.close()
		return score
	return content

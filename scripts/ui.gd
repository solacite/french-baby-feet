extends Control

@onready var p_1_score: Label = $Main/MarginContainer/HBoxContainer/MarginContainer/P1Score
@onready var p_2_score: Label = $Main/MarginContainer/HBoxContainer/MarginContainer2/P2Score

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var p1score = 0
var p2score = 0
var game_over = false

const WIN_SCORE = 1


func player_score(player_num: int):
	if game_over:
		return

	if player_num == 1:
		p1score += 1
		p_1_score.text = str(p1score)
	else:
		p2score += 1
		p_2_score.text = str(p2score)

	if p1score >= WIN_SCORE:
		win(1)
	elif p2score >= WIN_SCORE:
		win(2)


func win(player_num: int):
	$Main.winning = true
	$Main.winning_player = player_num
	game_over = true
	$AnimationPlayer.play_backwards("start_game")

extends Control

@onready var p_1_score: Label = $Main/HBoxContainer/P1Score
@onready var p_2_score: Label = $Main/HBoxContainer/P2Score


var p1score = 0
var p2score = 0

func player_score(player_num: int):
	
	if player_num == 1:
		p1score += 1
		p_1_score = p1score
	else:
		p2score += 1
		p_2_score = p2score

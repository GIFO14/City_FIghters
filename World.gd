#BSD 3-Clause License

#Copyright (c) 2019, Martí Blanes González
#All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
 #   * Redistributions of source code must retain the above copyright
 #     notice, this list of conditions and the following disclaimer.
 #   * Redistributions in binary form must reproduce the above copyright
 #     notice, this list of conditions and the following disclaimer in the
 #     documentation and/or other materials provided with the distribution.
 #   * Neither the name of the <organization> nor the
 #     names of its contributors may be used to endorse or promote products
 #     derived from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
#DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

extends Node
	
var players = []
var fruits = []
var fps_label = ""
var health_bars = []

var player1_deaths = 0
var player2_deaths = 0
var player1_deaths_counter_activated = true
var player2_deaths_counter_activated = true

func _process(delta):
	
	players = [get_node("/root/World/Player1"), get_node("/root/World/Player2")]
	fruits = [get_node("/root/World/Fruits/Cherry")]
	fps_label = get_node("/root/World/Text/FPS")
	health_bars = [get_node("/root/World/Health_bars/Player1_health"), get_node("/root/World/Health_bars/Player2_health")]
	
		
		
	
	if health_bars[0].value == 0 and player1_deaths_counter_activated:
		player1_deaths += 1
		var player1_deaths_text = "Deaths: " + String(player1_deaths)
		player1_deaths_counter_activated = false
		
		
		
	if health_bars[1].value == 0 and player2_deaths_counter_activated:
		player2_deaths += 1
		var player2_deaths_text = "Deaths: " + String(player2_deaths)
		player2_deaths_counter_activated = false
		
		
	
	if Input.is_action_just_pressed("ui_r"):
		
		if players[0].getHealth() <= 0 or players[1].getHealth() <= 0:
			
			var player1_pos = Vector2(players[0].getStart_pos().x, players[0].getStart_pos().y - 12)
			var player2_pos = Vector2(players[1].getStart_pos().x, players[1].getStart_pos().y - 15)
		
			players[0].setPosition(player1_pos)
			players[1].setPosition(player2_pos)
			
			players[0].setHealth(100)
			players[1].setHealth(100)
			
			players[0].setMove_allowed(true)
			players[1].setMove_allowed(true)
			
			get_node("/root/World/Health_bars/Player1_health").setValue(100)
			get_node("/root/World/Health_bars/Player2_health").setValue(100)
			
			fruits[0].setting_position()
			
		player1_deaths_counter_activated = true
		player2_deaths_counter_activated = true
	
	fps_label.set_text(String(Engine.get_frames_per_second()) + " fps")
	
	
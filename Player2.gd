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

extends KinematicBody2D

const PLAYER_NAME = "Player2"
const GRAVITY = 13
const SPEED = 300
const SPRINT = 125
const JUMP_HEIGHT = -400
const UP = Vector2(0, -1) 
const ATTACK_DAMAGE = 12.5

var jump_counter = 0
var motion = Vector2()
var health = 100
var move_allowed = true
var start_pos = Vector2()
var has_been_attacked = false
var hit_sound_has_sounded_for = 0

onready var attack_ray = get_node("Ray")
onready var hit_sound = get_node("/root/World/Sound/Hit")

func _ready():
	start_pos = self.position

func _physics_process(delta):
	motion.y += GRAVITY
	
	if move_allowed:
	
	#Basic movement
		if Input.is_action_pressed("ui_d"):
			motion.x = SPEED
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.flip_h = true
		
			if Input.is_action_pressed("ui_s"):
				motion.x = SPEED + SPRINT
		
			if attack_ray.cast_to.x < 0:
				attack_ray.cast_to.x *= -1
		
		elif Input.is_action_pressed("ui_a"):
			motion.x = -SPEED
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.flip_h = false
		
			if Input.is_action_pressed("ui_s"):
				motion.x = -SPEED - SPRINT
			
			if attack_ray.cast_to.x > 0:
				attack_ray.cast_to.x *= -1
		
		else:
			motion.x = 0
		
		if is_on_floor():
			if Input.is_action_just_pressed("ui_w"):
				motion.y = JUMP_HEIGHT
				jump_counter = 1
			
		elif jump_counter == 1:
			if Input.is_action_just_pressed("ui_w"):
				motion.y = JUMP_HEIGHT
				jump_counter = 0

	#Attack
		if Input.is_action_just_pressed("ui_f"):

			if attack_ray.is_colliding():
				get_thing_hit(attack_ray)
				
			$AnimatedSprite.animation = "punch"
		
			if Input.is_action_pressed("ui_a"):
				$AnimatedSprite.flip_h = false
			
			elif Input.is_action_pressed("ui_d"):
				$AnimatedSprite.flip_h = true
		
		if Input.is_action_just_pressed("ui_g"):
		
			if attack_ray.is_colliding():
				get_thing_hit(attack_ray)
				
			$AnimatedSprite.animation = "leg_hit"
		
			if Input.is_action_pressed("ui_a"):
				$AnimatedSprite.flip_h = false
			
			elif Input.is_action_pressed("ui_d"):
				$AnimatedSprite.flip_h = true
			
		if has_been_attacked:
			
			if hit_sound_has_sounded_for == 0:
				hit_sound.playing = true
			
			if hit_sound_has_sounded_for > 18:
				hit_sound.playing = false
				has_been_attacked = false
				hit_sound_has_sounded_for = 0
				
			else:
				hit_sound_has_sounded_for += 1
			
			
	
	#Has fallen into the void
		if position.y > 650:
			edit_health_and_healthbar(0,self)
			
	
	
	motion = move_and_slide(motion, UP)
	

	
func get_thing_hit(ray):
	var thing_hit = ray.get_collider()
			
	if thing_hit.is_in_group("player"):
		edit_health_and_healthbar(thing_hit.getHealth() - ATTACK_DAMAGE, thing_hit)
		
		
		
func edit_health_and_healthbar(health,thing_hit):
	
	var thing_hit_name = thing_hit.PLAYER_NAME
	
	thing_hit.setHealth(health)
		
	if thing_hit.getHealth() <= 0: 
		thing_hit.setMove_allowed(false)
		
	if thing_hit == self:
		thing_hit_name = PLAYER_NAME
		
	var health_bar = get_node("/root/World/Health_bars/%s_health" % thing_hit_name)
	health_bar.setValue(thing_hit.getHealth())
	
	if !(thing_hit == self):
		thing_hit.setHas_been_attacked(true)
		
		
	
func setHealth(current_health):
	health = current_health
	
	
	
func getHealth():
	return health
	
	
	
func setMove_allowed(allowed):
	move_allowed = allowed
	
	
	
func getStart_pos():
	return start_pos
	
	
	
func setPosition(pos):
	self.position = pos
	
	
	
func setHas_been_attacked(option):
	has_been_attacked = option
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

onready var collision_ray = get_node("Ray")
onready var collision_ray2 = get_node("Ray2")
onready var collision_ray3 = get_node("Ray3")
onready var collision_ray4 = get_node("Ray4")

const BONUS_HEALTH = 12.5
const GRAVITY = 1
const MAX_VELOCITY = 300

var setting_position_allowed = true
var motion = Vector2()
var rand_x = 0
#var y = 0
var frames_counter = 0
var current_velocity = 0


func _physics_process(delta):
	
	#Falling controll
	if current_velocity < MAX_VELOCITY:
		current_velocity += GRAVITY
	
	motion.y = current_velocity
	
	
	
	#Start position setter
	if setting_position_allowed:
		setting_position()
		setting_position_allowed = false
	
	
	
	#Collision control
	collision_ray.rotation_degrees += 1
	
	if collision_ray.is_colliding():
		collision_ray_actions(collision_ray)
			
	elif collision_ray2.is_colliding():
		collision_ray_actions(collision_ray2)
		
	elif collision_ray3.is_colliding():
		collision_ray_actions(collision_ray3)
		
	elif collision_ray4.is_colliding():
		collision_ray_actions(collision_ray4)
		
		
		
	#X movement avoid
	if 	position.x != rand_x:
		position.x = rand_x
		
		
	
	motion = move_and_slide(motion)
	
func setting_position():
	rand_x = randi()%901+210
	self.position = Vector2(rand_x, -1400)
		
	motion.y = -1400
		

	
func collision_ray_actions(ray):
	if ray.get_collider().is_in_group("player"):
		var thing_hit = ray.get_collider()
		edit_health_bar(thing_hit)
			
	setting_position_allowed = true
	
	
	
func edit_health_bar(thing_hit):
	if thing_hit.health < 100:
			thing_hit.setHealth(thing_hit.health + BONUS_HEALTH)
			
			var health_bar = get_node("/root/World/Health_bars/%s_health" % thing_hit.PLAYER_NAME)
			health_bar.setValue(thing_hit.getHealth())
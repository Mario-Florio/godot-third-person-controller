class_name ThirdPersonCharacter
extends CharacterBody3D

@export var collisionBody: CollisionShape3D
@export var visuals: Node3D
@export var controller: ThirdPersonController
@export var animationTree: AnimationTree
@export var viewProbe: ViewArea

func _ready():
	assert(controller != null)
	
	controller.characterBody = self
	controller.animationTree = animationTree
	controller.viewProbe = viewProbe
	controller.visuals = visuals
	controller.collisionBody = collisionBody
	
	if animationTree:
		controller.config.ANIMATION_CONFIG.is_grounded_path = (
			"parameters/Locomotion/conditions/is_grounded"
		)
		controller.config.ANIMATION_CONFIG.is_airborne_path = (
			"parameters/Locomotion/conditions/is_airborne"
		)
		controller.config.ANIMATION_CONFIG.grounded_blend_position_path = (
			"parameters/Locomotion/Grounded/blend_position"
		)
		controller.config.ANIMATION_CONFIG.airborne_blend_position_path = (
			"parameters/Locomotion/Airborne/blend_position"
		)

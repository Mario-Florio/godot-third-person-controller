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
	
	if animationTree:
		controller.config.animationConfig.is_grounded_path = (
			"parameters/Locomotion/conditions/is_grounded"
		)
		controller.config.animationConfig.is_airborne_path = (
			"parameters/Locomotion/conditions/is_airborne"
		)
		controller.config.animationConfig.grounded_blend_position_path = (
			"parameters/Locomotion/Grounded/blend_position"
		)
		controller.config.animationConfig.airborne_blend_position_path = (
			"parameters/Locomotion/Airborne/blend_position"
		)

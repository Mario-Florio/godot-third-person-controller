class_name ThirdPersonCharacter
extends CharacterBody3D

@export var collisionBody: CollisionShape3D
@export var visuals: Node3D
@export var controller: ThirdPersonController

func _ready() -> void:
	controller.characterBody = self

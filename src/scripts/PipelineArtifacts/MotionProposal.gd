class_name MotionProposal
extends RefCounted

# Abstract Class - DO NOT USE DIRECTLY (use concrete classes instead)

# Using
const ForceApplication := MotionAuthority.ForceApplication

var priority    : float            # 0 being the highest
var application : ForceApplication # Represents application of force
var magnitude   : float            # Represents actual force produced [0 - 1]

func _init(_priority: int, _application: ForceApplication, _magnitude: float) -> void:
	priority = _priority
	application = _application
	magnitude = clamp(_magnitude, 0.0, 1.0)

func submit(_proposalAuthority: ProposalReviewer) -> void:
	pass

# ------------------
# Concrete Classes
# ------------------
class Horizontal extends MotionProposal:
	var planar_vector: Vector2 # maps desired horizontal direction (x, z) onto Vector2's x, y; (x -> x, z -> y)
	
	func _init(_priority: int, _application: ForceApplication, _magnitude: float, _planar_vector: Vector2) -> void:
		super(_priority, _application, _magnitude)
		planar_vector = _planar_vector
	
	func submit(proposalAuthority: ProposalReviewer) -> void:
		proposalAuthority.review_horizontal(self)


class Rotational extends MotionProposal:
	var yaw: float
	
	func _init(_priority: int, _application: ForceApplication, _magnitude: float, _yaw: float) -> void:
		super(_priority, _application, _magnitude)
		yaw = _yaw
	
	func submit(proposalAuthority: ProposalReviewer) -> void:
		proposalAuthority.review_rotational(self)

class Vertical extends MotionProposal:
	func submit(proposalAuthority: ProposalReviewer) -> void:
		proposalAuthority.review_vertical(self)

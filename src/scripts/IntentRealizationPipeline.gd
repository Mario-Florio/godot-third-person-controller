class_name IntentRealizationPipeline
extends RefCounted

# Domain Controllers
var agentInputHandler   : AgentInputHandler
var viewManager         : ViewManager
var viewSemantics       : ViewSemantics
var locomotionSemantics : LocomotionSemantics
var motionAuthority     : MotionAuthority
var animationHandler    : AnimationHandler
var viewProbe           : ViewProbe
var positionAuthority   : PositionAuthority

# Responsibilities
var inputInterface        : InputInterface
var viewIntentMediation   : ViewIntentMediation
var intentResolution      : IntentResolution
var realizationAuthority  : RealizationAuthority
var presentationMediation : PresentationMediation

# System Context
var observability: Observability

## Core pipeline setup. All required dependencies must be met
func setup(config: ThirdPersonControllerConfig, characterBody: CharacterBody3D, _observability: Observability) -> void:
	assert(config != null, "Config must be provided at setup [IntentRealizationPipeline.setup]")
	assert(characterBody != null, "Character body must be provided at setup [IntentRealizationPipeline.setup]")
	assert(_observability != null, "Observability must be provided at setup [IntentRealizationPipeline.setup]")
	
	observability = _observability
	
	_constructDomainControllers(config, characterBody)
	_constructResponsibilities()
	_connectDomains()

## Setter for initial view. Optional dependency; only required if not using dynamic view discovery (e.g., ViewProbe).
## All optional dependencies must be set after core pipeline is setup.
func setInitialView(initialView: ViewInterface) -> void:
	assert(initialView != null, "Initial view not provided [IntentRealizationPipeline.setInitialView]")
	
	viewManager.setInitialView(initialView)

## Setter for animation handler. Optional dependency; only required if using animation tree.
## All optional dependencies must be set after core pipeline is setup.
func setAnimationHandler(animationConfig: AnimationConfig, animationTree: AnimationTree) -> void:
	assert(animationConfig != null, "Animation config not provided [IntentRealizationPipeline.setAnimationHandler]")
	assert(animationTree != null, "Animation tree not provided [IntentRealizationPipeline.setAnimationHandler]")
	
	if animationHandler:
		animationHandler.setAnimationTree(animationTree)
	
	else:
		var tracerAPI := observability.getTracerAPI(Observability.TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE)
		animationHandler = AnimationHandler.new(animationConfig, tracerAPI, animationTree)
		presentationMediation.setAnimationHandler(animationHandler)

## Setter for view probe. Optional dependency; only required if using dynamic view discovery.
## All optional dependencies must be set after core pipeline is setup.
func setViewProbe(viewArea: ViewArea) -> void:
	assert(viewArea != null, "View area not provided [IntentRealizationPipeline.setViewProbe]")
	
	if viewProbe:
		viewProbe.setViewArea(viewArea)
	
	else:
		viewProbe = ViewProbe.new(viewArea)
		inputInterface.setViewProbe(viewProbe)
		_connectViewProbe()

## Setter for visuals. Optional dependency.
## All optional dependencies must be set after core pipeline is setup.
func setVisuals(visuals: Node3D, pivot_offset: float) -> void:
	assert(visuals != null, "Visuals not provided [IntentRealizationPipeline.setVisuals]")
	
	presentationMediation.setVisuals(visuals)
	if pivot_offset:
		presentationMediation.align_visual_pivot_offset(pivot_offset)

## Setter for position authority. Optional dependency; only required if want to configure collision body position.
## All optional dependencies must be set after core pipeline is setup.
func setPositionAuthority(positionConfig: PositionConfig, collisionBody: CollisionShape3D) -> void:
	assert(positionConfig != null, "Position config not provided [IntentRealizationPipeline.setPositionAuthority]")
	assert(collisionBody != null, "Collision body not provided [IntentRealizationPipeline.setPositionAuthority]")
	
	if positionAuthority:
		positionAuthority.setCollisionBody(collisionBody)
	
	else:
		positionAuthority = PositionAuthority.new(positionConfig, collisionBody)
		realizationAuthority.setPositionAuthority(positionAuthority)
		positionAuthority.connectConfigHandler("pivot_offset_updated", presentationMediation.align_visual_pivot_offset)

func notify(event: InputEvent) -> void:
	agentInputHandler.notify(event)

func run(delta: float) -> void:
	var tracerAPI := observability.getTracerAPI(Observability.TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE)
	var span_token := tracerAPI.START_SPAN(Observability.SpanNames.INTENT_REALIZATION_PIPELINE_RUN)
	
	inputInterface.execute()
	var intentBearingInput := inputInterface.produce()
	
	viewIntentMediation.execute(intentBearingInput)
	var referenceBasis := viewIntentMediation.produce()
	
	intentResolution.execute(
		intentBearingInput,
		referenceBasis,
		realizationAuthority.produce()
	)
	var semanticIntent := intentResolution.produce()
	
	realizationAuthority.execute(delta, semanticIntent)
	
	presentationMediation.execute(
		delta,
		referenceBasis,
		semanticIntent,
		realizationAuthority.produce())
	
	tracerAPI.END_SPAN(span_token)
	tracerAPI.END_FRAME()

# Utils
func _constructDomainControllers(config : ThirdPersonControllerConfig, characterBody: CharacterBody3D) -> void:
	var tracerAPI := observability.getTracerAPI(Observability.TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE)
	
	agentInputHandler   = AgentInputHandler.new(config.INPUT_CONFIG, tracerAPI)
	viewManager         = ViewManager.new(tracerAPI)
	viewSemantics       = ViewSemantics.new(config.VIEW_CONFIG, tracerAPI)
	locomotionSemantics = LocomotionSemantics.new(config.LOCOMOTION_CONFIG, tracerAPI)
	motionAuthority     = MotionAuthority.new(config.MOTION_CONFIG, tracerAPI, characterBody)

func _constructResponsibilities() -> void:
	var tracerAPI := observability.getTracerAPI(Observability.TracerNames.INTENT_REALIZATION_PIPELINE_CYCLE)
	
	inputInterface        = InputInterface.new(agentInputHandler, tracerAPI)
	viewIntentMediation   = ViewIntentMediation.new(viewManager, viewSemantics, tracerAPI)
	intentResolution      = IntentResolution.new(locomotionSemantics, tracerAPI)
	realizationAuthority  = RealizationAuthority.new(motionAuthority, tracerAPI)
	presentationMediation = PresentationMediation.new(animationHandler, tracerAPI)

func _connectDomains() -> void:
	viewManager.connect("active_view_updated", viewSemantics.on_view_updated)

func _connectViewProbe() -> void:
	assert(viewProbe != null, "View Probe is not initialized [IntentRealizationPipeline._connectViewProbe]")
	
	viewProbe.connectHandler("view_discovered", viewManager.view_discovered)
	viewProbe.connectHandler("view_lost", viewManager.view_lost)

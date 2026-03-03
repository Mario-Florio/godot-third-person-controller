class_name IntentRealizationPipeline
extends RefCounted

# Domain Controllers
var agentInputHandler   : AgentInputHandler
var viewManager         : ViewManager
var viewSemantics       : ViewSemantics
var locomotionSemantics : LocomotionSemantics
var motionAuthority     : MotionAuthority

# Responsibilities
var inputInterface        : InputInterface
var viewIntentMediation   : ViewIntentMediation
var intentResolution      : IntentResolution
var realizationAuthority  : RealizationAuthority
var presentationMediation : PresentationMediation

func setup(
	config: ThirdPersonControllerConfig,
	initialView: ViewInterface,
	characterBody: CharacterBody3D
) -> void:
	
	_constructDomainControllers(config, characterBody)
	_constructResponsibilities()
	_connectDomains()
	
	if initialView:
		viewManager.setInitialView(initialView)

func notify(event: InputEvent) -> void:
	agentInputHandler.notify(event)

func run(delta: float) -> void:
	inputInterface.execute()
	var intentBearingInput := inputInterface.produce()
	
	viewIntentMediation.execute(intentBearingInput)
	var referenceBasis := viewIntentMediation.produce()
	
	intentResolution.execute(
		intentBearingInput,
		referenceBasis,
		realizationAuthority.produce()
	)
	
	realizationAuthority.execute(delta, intentResolution.produce())
	
	presentationMediation.execute(realizationAuthority.produce())

# Utils
func _constructDomainControllers(
	config : ThirdPersonControllerConfig,
	characterBody: CharacterBody3D
) -> void:
	
	agentInputHandler = AgentInputHandler.new(config.inputConfig)
	viewManager       = ViewManager.new()
	viewSemantics     = ViewSemantics.new(config.viewConfig)
	locomotionSemantics = LocomotionSemantics.new(config.locomotionConfig)
	motionAuthority = MotionAuthority.new(config.motionConfig, characterBody)

func _constructResponsibilities() -> void:
	inputInterface        = InputInterface.new(agentInputHandler)
	viewIntentMediation   = ViewIntentMediation.new(viewManager, viewSemantics)
	intentResolution      = IntentResolution.new(locomotionSemantics)
	realizationAuthority  = RealizationAuthority.new(motionAuthority)
	presentationMediation = PresentationMediation.new()

func _connectDomains() -> void:
	viewManager.connect("active_view_updated", viewSemantics.on_view_updated)

class_name IntentRealizationPipeline
extends RefCounted

# Responsibilities
var inputInterface        : InputInterface
var viewIntentMediation   : ViewIntentMediation
var intentResolution      : IntentResolution
var realizationAuthority  : RealizationAuthority
var presentationMediation : PresentationMediation

func setup(config: ThirdPersonControllerConfig) -> void:
	_constructResponsibilities()

func notify(event: InputEvent) -> void:
	pass

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
	
	realizationAuthority.execute(
		delta,
		intentBearingInput,
		referenceBasis,
		intentResolution.produce()
	)
	
	presentationMediation.execute(realizationAuthority.produce())

# Utils
func _constructResponsibilities() -> void:
	inputInterface        = InputInterface.new()
	viewIntentMediation   = ViewIntentMediation.new()
	intentResolution      = IntentResolution.new()
	realizationAuthority  = RealizationAuthority.new()
	presentationMediation = PresentationMediation.new()

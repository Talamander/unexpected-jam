extends CanvasLayer

onready var container = $Polygon2D
onready var waveText = $Label
onready var decayTimer = $Timer
onready var animator = $AnimationPlayer

var previousModifier = Global.currentModifier

func _ready():
	container.visible = false
	waveText.visible = false

# warning-ignore:unused_argument
func _physics_process(delta):
	if Global.currentModifier != previousModifier:
		container.visible = true
		waveText.visible = true
		animator.play("Fade In")
		previousModifier = Global.currentModifier
		
		decayTimer.start()



func _on_Timer_timeout():
		animator.play("Fade Out")

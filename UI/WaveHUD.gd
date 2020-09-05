extends CanvasLayer

onready var container = $Polygon2D
onready var waveText = $Polygon2D/RichTextLabel
onready var decayTimer = $Timer
onready var animator = $AnimationPlayer

var previousWave = Global.currentWave

func _ready():
	pass

func _physics_process(delta):
	if Global.currentWave != previousWave:
		animator.play("Fade In")
		previousWave = Global.currentWave
		var currentWaveText = ("Wave ")
		var waveNumber = str(Global.currentWave)
		currentWaveText = currentWaveText + waveNumber
		waveText.set_bbcode(currentWaveText)
		
		decayTimer.start()



func _on_Timer_timeout():
		animator.play("Fade Out")

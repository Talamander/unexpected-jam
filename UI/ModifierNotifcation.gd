extends CanvasLayer

#onready var container = $Polygon2D
onready var hintText = $Label
onready var decayTimer = $Timer
onready var animator = $AnimationPlayer

var previousModifier = Global.currentModifier

func _ready():
	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	if Global.hints_enabled == true:
		set_hint()
	if Global.currentModifier != previousModifier:
		animator.play("Fade In")
		previousModifier = Global.currentModifier
		decayTimer.start()

func set_hint():
	if Global.currentModifier == "SlowMotion":
		hintText.text = "Take it nice and easy..."
	if Global.currentModifier == "PlayerDamageIncrease":
		hintText.text = "Your bullets pack a punch"
	if Global.currentModifier == "ReverseMovement":
		hintText.text = "tnemevoM esreveR"
	if Global.currentModifier == "RecoilRange":
		hintText.text = "Fly baby, fly"
	if Global.currentModifier == "NoRecoil":
		hintText.text = "Dexterity +100"
	if Global.currentModifier == "BasicRuleSet":
		hintText.text = "You're an OG now"
	if Global.currentModifier == "killSwitch":
		hintText.text = "Use this wisely"
	if Global.currentModifier == "noMiniMap":
		hintText.text = "Where is everyone?"
	if Global.currentModifier == "infiniteAmmo":
		hintText.text = "That's one big magazine"
	if Global.currentModifier == "twoShot":
		hintText.text = "Say hello to my little friend!"
	if Global.currentModifier == "chargeShot":
		hintText.text = "So anyway I prepared to start Blastin'"
func _on_Timer_timeout():
		animator.play("Fade Out")

extends Spatial

export var walking: bool = false

var time: float = 0.0
const CYCLE: float = 0.4

func _process(delta: float) -> void:
	time = fmod(time + delta, CYCLE)
	if walking:
		if time < CYCLE * 0.3:
			$Char_Leg_RIght2.hide()
			$Char_Leg_Left2.hide()
			$Char_Arm_Left2.hide()
			$Char_Arm_Right2.hide()
			$Walk1.show()
			$Walk2.hide()
		elif time < CYCLE * 0.5:
			$Char_Leg_RIght2.show()
			$Char_Leg_Left2.show()
			$Char_Arm_Left2.show()
			$Char_Arm_Right2.show()
			$Walk1.hide()
			$Walk2.hide()
		elif time < CYCLE * 0.8:
			$Char_Leg_RIght2.hide()
			$Char_Leg_Left2.hide()
			$Char_Arm_Left2.hide()
			$Char_Arm_Right2.hide()
			$Walk1.hide()
			$Walk2.show()
		else:
			$Char_Leg_RIght2.show()
			$Char_Leg_Left2.show()
			$Char_Arm_Left2.show()
			$Char_Arm_Right2.show()
			$Walk1.hide()
			$Walk2.hide()
	else:
		$Char_Leg_RIght2.show()
		$Char_Leg_Left2.show()
		$Char_Arm_Left2.show()
		$Char_Arm_Right2.show()
		$Walk1.hide()
		$Walk2.hide()

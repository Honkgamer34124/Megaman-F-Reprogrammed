extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Group/soundEffectVolume/HSlider.value=GlobalScript.soundEffectVolumeDB
	$Group/BGMVolume/HSlider.value=GlobalScript.BGMVolumeDB

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_go_back_pressed():
	queue_free()


func _onSoundEffectVol_slider_drag_ended(value_changed):
	print(name,"->soundvolume changed")
	#if GlobalScript.soundEffectVolumeDB:
	GlobalScript.soundEffectVolumeDB=$Group/soundEffectVolume/HSlider.value
	print(name,"->saving new Volume of ",GlobalScript.soundEffectVolumeDB)


func _on_BGMVolumeSlider_drag_ended(value_changed):
	GlobalScript.BGMVolumeDB=$Group/BGMVolume/HSlider.value#+10 #aded cause of volume reduction upon pausing

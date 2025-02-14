extends Node2D
var chargetimer=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func chargeeffect(animated_sprite:AnimatedSprite2D):
	if chargetimer==0:
		animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(136.0,232.0,255.0,255.0))/255)
		animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(0.0,98.0,247.0,255.0))/255)
	elif chargetimer>0 and chargetimer<30:
		if chargetimer%10==1:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif chargetimer%10==5:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif chargetimer>30 and chargetimer<75:
		if chargetimer%10==1:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
		elif chargetimer%10==5:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)
	elif chargetimer>75:
		if chargetimer%5==1:
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(0.0,98.0,247.0,255.0))/255)
		elif chargetimer%5==3:
			animated_sprite.material.set_shader_parameter("chargecolorI",(Vector4(137.0,233.0,255.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("chargecolorII",(Vector4(0.0,0.0,0.0,255.0))/255)
			animated_sprite.material.set_shader_parameter("bodyoutlcharge",(Vector4(135.0,0.0,142.0,255.0))/255)

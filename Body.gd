#From the Book:
#Create Compelling Science and Engineering Simulations Using the Godot Engine, Copyright 2024 Burney Waring, ThankGod Egbe, Lateef Kareem 
#Chapter 6

extends Sprite

var v1 
var v2 
var L
var t = 0 
var Angle 
var Omega = 10
var R
var res

# Called when the node enters the scene tree for the first time.
func _ready():
	res = funcref(self, "_Equ")
	v1 = $Head.position - $Plunger.position
	L = _Hypot(v1.x, v1.y)
	v1 = v1/L
	R = _Hypot($Plunger.position.x, $Plunger.position.y)

func _process(delta):
	t += delta
	# Rotation Angle from Initial State
	Angle = t * Omega
	$Crank.rotation = Angle
	# Compute Plunger Position
	$Plunger.position = R*Vector2(sin(Angle), -cos(Angle))
	# Compute Head Position
	$Head.position.y = -_Bisect(res, L - R, L + R)
	# Compute New Orientation of Plunger
	v2 = ($Head.position - $Plunger.position)/L
	# Orientation of Plunger Relative to initial Orientation
	$Plunger.rotation = asin((v1.cross(v2)))
	pass

func _Hypot(x, y):
	return sqrt(x*x + y*y)
	
func _Equ(v):
	var eq = R*R + v*v - L*L - 2*R*v*cos(Angle)
	return eq

func _Bisect(fun, a, b):
	var c = 0.5*(a+b)
	var fa = fun.call_func(a) 
	var fb = fun.call_func(b) 
	while(abs(a-b) > 1e-3):
		var fc = fun.call_func(c)
		if(fa*fc < 0):
			b = c
			fb = fc
		else:
			a = c
			fa = fc

		c = 0.5*(a+b) 
	return c

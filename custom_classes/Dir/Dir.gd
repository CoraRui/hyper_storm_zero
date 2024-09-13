extends Node
class_name Dir
#contains structures for directional information.

#none means Vector(0,0). im assuming theres a use for that.

enum Dir4 {UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, NONE = 4, INVALID = 5}

enum Dir8 {U = 0, D = 1, L = 2, R = 3, UL = 4, UR = 5, DL = 6, DR = 7, NONE = 8, INVALID = 9}

#directions to other sorts of measurements

static func dir4_to_uvec( dir : Dir4 ) -> Vector2i:
	match dir:
		Dir4.UP:
			return Vector2(0,1)
		Dir4.DOWN:
			return Vector2(0,-1)
		Dir4.LEFT:
			return Vector2(-1,0)
		Dir4.RIGHT:
			return Vector2(1,0)
		Dir4.NONE:
			return Vector2(0,0)
		_:
			print("direction got a weird parameter, shouldnt be here. returned 0,0 ")
			return Vector2(0,0)
		
static func dir4_to_dir8( vec : Dir4 ) -> Dir8:
	
	match vec:
		Dir4.UP:
			return Dir8.U
		Dir4.DOWN:
			return Dir8.D
		Dir4.LEFT:
			return Dir8.L
		Dir4.RIGHT:
			return Dir8.R
		Dir4.NONE:
			return Dir8.NONE
		Dir4.INVALID:
			return Dir8.INVALID
		_:
			return Dir8.INVALID
			
static func uvec_to_dir4( vec : Vector2i ) -> Dir4:
	match vec:
		Vector2(0,1):
			return Dir4.UP
		Vector2(0,-1):
			return Dir4.DOWN
		Vector2(1,0):
			return Dir4.RIGHT
		Vector2(-1,0):
			return Dir4.LEFT
		Vector2(0,0):
			return Dir4.NONE
		_:
			print("uvec to dir received a non unit vector, returning none.")
			return Dir4.NONE
	
static func uvec_to_dir8( vec : Vector2i ) -> Dir8:
	match vec:
		Vector2(0,0):
			return Dir8.NONE
		Vector2(0,1):
			return Dir8.U
		Vector2(0,-1):
			return Dir8.D
		Vector2(-1,0):
			return Dir8.L
		Vector2(1,0):
			return Dir8.R
		Vector2(1,1):
			return Dir8.UR
		Vector2(-1,1):
			return Dir8.UL
		Vector2(1,-1):
			return Dir8.DR
		Vector2(-1,-1):
			return Dir8.DL
		_:
			return Dir8.INVALID
			
static func dir8_to_uvec( vec : Dir8 ) -> Vector2i:
	
	match vec:
		Dir8.U:
			return Vector2(0,1)
		Dir8.UL:
			return Vector2(-1,1)
		Dir8.UR:
			return Vector2(1,1)
		Dir8.R:
			return Vector2(1,0)
		Dir8.DR:
			return Vector2(1,-1)
		Dir8.D:
			return Vector2(0,-1)
		Dir8.DL:
			return Vector2(-1,-1)
		Dir8.L:
			return Vector2(-1,0)
		Dir8.INVALID:
			return Vector2(0,0)
		_:
			return Vector2(0,0)
			
static func dir8_to_dir_4( vec : Dir8, x_axis : bool) -> Dir4:
	#locks diagonals to a single axis. thats the only way i think thisll make sense.
	#i dont know what else i would need a function like this for anyways.
	
	if(x_axis):
		match vec:
			Dir8.UL || Dir8.DL || Dir8.L:
				return Dir4.LEFT
			Dir8.UR || Dir8.DR || Dir8.R:
				return Dir4.RIGHT
			Dir8.U:
				return Dir4.UP
			Dir8.D:
				return Dir4.DOWN
			Dir8.NONE:
				return Dir4.NONE
			Dir8.INVALID:
				return Dir4.INVALID
			_:
				return Dir4.INVALID
	else:
		match vec:
			Dir8.UL || Dir8.UR || Dir8.U:
				return Dir4.UP
			Dir8.DL || Dir8.DR || Dir8.D:
				return Dir4.DOWN
			Dir8.L:
				return Dir4.LEFT
			Dir8.R:
				return Dir4.RIGHT
			Dir8.NONE:
				return Dir4.NONE
			Dir8.INVALID:
				return Dir4.INVALID
			_:
				return Dir4.INVALID
	
static func dir8_to_point(from : Vector2, to : Vector2) -> Dir8:
	#should take two points, from and to, and return the approximate direction between them in dir8 terms
	#so how do i determine which quadrant the to vector is in, and how do i decide which function to use
	var dir : Dir8
	
	var dvec : Vector2 = to - from
	
	var angle : float
	
	#calculate the angle between the two points
	if dvec.x >= 0 && dvec.y <= 0:
		#quad 1
		angle = rad_to_deg(atan(dvec.y/dvec.x))
	if dvec.x < 0 && dvec.y <= 0:
		#quad 2
		angle = 180 - rad_to_deg(atan(dvec.y/dvec.x))
	if dvec.x < 0 && dvec.y > 0:
		#quad 3
		angle = 180 - rad_to_deg(atan(dvec.y/dvec.x))
	if dvec.x >= 0 && dvec.y > 0:
		#quad 4
		angle = 360 - rad_to_deg(atan(dvec.y/dvec.x))
	
	#return a dir dependent on the range of the angle
	
	if 0 <= angle && angle < 22.5:
		return Dir8.R
	if 22.5 <= angle && angle < 67.5:
		return Dir8.UR
	if 67.5 <= angle && angle < 112.5:
		return Dir8.U
	if 112.5 <= angle && angle < 157.5:
		return Dir8.UL
	if 157.5 <= angle && angle < 202.5:
		return Dir8.L
	if 202.5 <= angle && angle < 247.5:
		return Dir8.DL
	if 247.5 <= angle && angle < 292.5:
		return Dir8.D
	if 292.5 <= angle && angle < 337.5:
		return Dir8.DR
	if 337.5 <= angle && angle <= 360:
		return Dir8.R
	
	return dir


extends Node
class_name var_to_string

#static class for converting different data types to and from strings.


static func str_to_vector2i(s : String) -> Vector2i:
	#should accept a string of the format: (x,y)
	var new_vec : Vector2i = Vector2i(0,0)
	
	#i want a while loop that goes through all of the characters (right to left cause easier)
	#adding up the values into the new_vec
	var i : int = s.length() - 2
	
	var b : int = 1
	while(s[i] != ','):
		if s[i].to_int() is int:
			#add the value to the y coord, multiplied by the base. for place value
			new_vec.y += s[i].to_int() * b
		else:
			print("str_to_vector2i was passed a strange value, returned (0,0)")
			return Vector2i(0,0)
		i -= 1
		b *= 10
	
	b = 1
	while(s[i] != '('):
		if s[i].to_int() is int:
			#add the value to the y coord, multiplied by the base. for place value
			new_vec.x += s[i].to_int() * b
		else:
			print("str_to_vector2i was passed a strange value, returned (0,0)")
			return Vector2i(0,0)
		i -= 1
		b *= 10
	
	
	return new_vec


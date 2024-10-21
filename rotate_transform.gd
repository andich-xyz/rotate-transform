@tool
class_name VisualShaderNodeRotateTransform extends VisualShaderNodeCustom

func _get_name() -> String:
	return "RotateTransform"
	
func _get_category() -> String:
	return "Transform"

func _get_code(input_vars: Array[String], output_vars: Array[String], mode: Shader.Mode, type: VisualShader.Type) -> String:
	return output_vars[0] + " = getMatrix(%s, %s, %s);" % [input_vars[0], input_vars[1], get_option_index(0)]

func _get_default_input_port(type: PortType) -> int:
	return VisualShaderNode.PORT_TYPE_SCALAR

func _get_description() -> String:
	return "Get Rotation Matrix along the specified axis"

func _init() -> void:
	set_input_port_default_value(0, 1.0)
	set_input_port_default_value(1, 0.0)

func _get_property_count() -> int:
	return 1

func _get_property_default_index(index: int) -> int:
	return 0

func _get_property_name(index: int) -> String:
	return "Axis"

func _get_property_options(index: int) -> PackedStringArray:
	return ["X", "Y", "Z"]

func _get_global_code(mode: Shader.Mode) -> String:
	return """
float getTime(float speed, float offset) {
	return fract(TIME * speed + offset) * 2.0 * PI;
}

mat4 getMatrix(float speed, float offset, int axis) {
	float cosine = cos(getTime(speed, offset));
	float sine = sin(getTime(speed, offset));
	mat4 resultMat;
	vec4 x_comp = vec4(1.0, 0.0, 0.0, 0.0);
	vec4 y_comp = vec4(0.0, 1.0, 0.0, 0.0);
	vec4 z_comp = vec4(0.0, 0.0, 1.0, 0.0);
	vec4 w_comp = vec4(0.0, 0.0, 0.0, 1.0);
	switch (axis) {
		case 0:
			x_comp = vec4(1.0, 0.0, 0.0, 0.0);
			y_comp = vec4(0.0, cosine, -1.0 * sine, 0.0);
			z_comp = vec4(0.0, sine, cosine, 0.0);
			w_comp = vec4(0.0, 0.0, 0.0, 1.0);
			mat4 resultMat = mat4(x_comp, y_comp, z_comp, w_comp);
			return resultMat;
		case 1:
			x_comp = vec4(cosine, 0.0, sine, 0.0);
			y_comp = vec4(0.0, 1.0, 0.0, 0.0);
			z_comp = vec4(-1.0 * sine, 0.0, cosine, 0.0);
			w_comp = vec4(0.0, 0.0, 0.0, 1.0);
			mat4 resultMat = mat4(x_comp, y_comp, z_comp, w_comp);
			return resultMat;
		case 2:
			x_comp = vec4(cosine, -1.0 * sine, 0.0, 0.0);
			y_comp = vec4(sine, cosine, 0.0, 0.0);
			z_comp = vec4(0.0, 0.0, 1.0, 0.0);
			w_comp = vec4(0.0, 0.0, 0.0, 1.0);
			mat4 resultMat = mat4(x_comp, y_comp, z_comp, w_comp);
			return resultMat;
	}
	//mat4 resultMat = mat4(x_comp, y_comp, z_comp, w_comp);
	//return resultMat;
}
	"""

func _get_input_port_count() -> int:
	return 2

func _get_input_port_default_value(port: int) -> Variant:
	match port:
		0:
			return 1.0
		1:
			return 0.0
		_:
			return 0.0

func _get_input_port_name(port: int) -> String:
	match port:
		0:
			return "Speed"
		1:
			return "Offset"
		_:
			return "error"

func _get_input_port_type(port: int) -> PortType:
	match port:
		0:
			return VisualShaderNode.PORT_TYPE_SCALAR
		1:
			return VisualShaderNode.PORT_TYPE_SCALAR
		_:
			return VisualShaderNode.PORT_TYPE_BOOLEAN

func _get_output_port_count() -> int:
	return 1

func _get_output_port_name(port: int) -> String:
	return "Transform"

func _get_output_port_type(port: int) -> PortType:
	return VisualShaderNode.PORT_TYPE_TRANSFORM

func _get_return_icon_type() -> PortType:
	return VisualShaderNode.PORT_TYPE_TRANSFORM

func _is_available(mode: Shader.Mode, type: VisualShader.Type) -> bool:
	return type == VisualShader.TYPE_VERTEX

func _is_highend() -> bool:
	return false

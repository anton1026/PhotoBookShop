attribute vec4 position;
attribute vec3 normal;
attribute vec2 texcoord;

varying lowp vec2 v_texcoord;
varying lowp vec3 v_vert;
varying lowp vec3 v_normal;
varying lowp vec3 v_normalp;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main()
{
    v_normalp=normal;
    v_normal = normalize(normalMatrix * normal);
    v_texcoord = texcoord;
	vec4 vert4 = modelViewMatrix * position;
	v_vert = vert4.xyz/vert4.w;
	
    gl_Position = modelViewProjectionMatrix * position;
}

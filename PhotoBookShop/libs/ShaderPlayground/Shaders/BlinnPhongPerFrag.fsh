precision mediump float;

varying lowp vec2 v_texcoord;
varying lowp vec3 v_vert;
varying lowp vec3 v_normal;
varying lowp vec3 v_normalp;
uniform sampler2D texture;
uniform vec3 lightDir;

 const vec3 lightPos = vec3(10.0, 10.0, -10.0);
const vec3 ambientColor = vec3(0.1, 0.1, 0.1);
const vec3 diffuseColor = vec3(0.1, 0.1, 0.1);
const vec3 specColor = vec3(1.0, 1.0, 1.0);

void main()
{
	vec3 tNormal = normalize(v_normal);
	vec3 tLight = normalize(lightDir - v_vert);
	
	float lambertian = max(dot(tLight, tNormal), 0.0);
	float specular = 0.0;
	
	if (lambertian>0.0)
	{
		vec3 viewDir = normalize(-v_vert);
		
		vec3 halfDir = normalize(tLight+viewDir);
		float specAngle = max(dot(halfDir, tNormal), 0.0);
		specular = pow(specAngle, 64.0);
	}
    if (v_normalp.z==0.0){
         gl_FragColor = vec4(ambientColor, 1.0) + texture2D(texture, vec2(-v_texcoord.x,v_texcoord.y)) + vec4(specular*specColor, 1.0);
    }else
    gl_FragColor = vec4(0.5,0.5,0.5, 0.5) +  vec4(specular*specColor, 1.0);
}

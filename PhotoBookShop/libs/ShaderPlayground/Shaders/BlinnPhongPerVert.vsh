//
//  BlinnPhong.vsh
//  ShaderPlayground
//
//  Created by K-Res on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texcoord;

varying lowp vec2 v_texcoord;
varying lowp vec3 v_diffcolor;
varying lowp vec3 v_speccolor;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightDir;

const vec3 specColor = vec3(1.0, 1.0, 1.0);
const vec3 diffColor = vec3(1.0, 1.0, 1.0);

void main()
{
    vec3 v_normal = normalize(normalMatrix * normal);
    v_texcoord = texcoord;
	vec4 vert4 = modelViewMatrix * position;
	vec3 v_vert = vert4.xyz/vert4.w;
	
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
	
	v_speccolor = specular*specColor;
	v_diffcolor = diffColor*lambertian;
	
    gl_Position = modelViewProjectionMatrix * position;
}

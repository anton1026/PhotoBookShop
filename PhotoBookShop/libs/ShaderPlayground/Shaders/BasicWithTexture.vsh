//
//  BasicWithFullColor.vsh
//  ShaderPlayground
//
//  Created by K-Res on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texcoord;

varying lowp vec2 texcoordVarying;
varying mediump float dotVP;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
    
    dotVP = nDotVP;
    texcoordVarying = texcoord;
    
    gl_Position = modelViewProjectionMatrix * position;
}

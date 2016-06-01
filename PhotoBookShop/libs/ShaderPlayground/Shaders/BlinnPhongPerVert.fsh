//
//  BlinnPhong.fsh
//  ShaderPlayground
//
//  Created by K-Res on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

precision mediump float;

varying lowp vec2 v_texcoord;
varying lowp vec3 v_diffcolor;
varying lowp vec3 v_speccolor;

uniform sampler2D texture;

const vec3 ambientColor = vec3(0.1, 0.0, 0.0);

void main()
{
	gl_FragColor = vec4(ambientColor, 1.0) + vec4(v_speccolor, 1.0) + vec4(v_diffcolor, 1.0)*texture2D(texture, v_texcoord);
}

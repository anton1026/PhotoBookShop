//
//  BasicWithFullColor.fsh
//  ShaderPlayground
//
//  Created by K-Res on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

varying lowp vec2 texcoordVarying;
varying mediump float dotVP;

uniform sampler2D texture;

void main()
{
    gl_FragColor = dotVP*texture2D(texture, texcoordVarying);
}

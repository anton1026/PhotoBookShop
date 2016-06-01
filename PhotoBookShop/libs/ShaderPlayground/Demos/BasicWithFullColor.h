//
//  BasicWithFullColor.h
//  ShaderPlayground
//
//  Created by K-Res on 14-5-12.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#ifndef __ShaderPlayground__BasicWithFullColor__
#define __ShaderPlayground__BasicWithFullColor__

#include "DemoBase.h"
#include "../Eigen/Dense"

using namespace Eigen;

class BasicWithFullColor : public DemoBase
{
public:
    BasicWithFullColor();
    
    virtual void SetupGL();
    virtual void TearDownGL();
    virtual void Update(const float viewWidth, const float viewHeight, const float time);
    virtual void Render();
private:
    float _rotation;
    
    Matrix4f _matMVP1;
    Matrix3f _matNormal1;
    
    Matrix4f _matMVP2;
    Matrix3f _matNormal2;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    Shader* _shader;
    
    float _color[4];
    float _colorStep[4];
};

#endif /* defined(__ShaderPlayground__BasicWithFullColor__) */

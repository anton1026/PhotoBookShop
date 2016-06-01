//
//  BasicWithTexture.h
//  ShaderPlayground
//
//  Created by Zhu Wen on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#ifndef __ShaderPlayground__BasicWithTexture__
#define __ShaderPlayground__BasicWithTexture__

#include "DemoBase.h"
#include "../Eigen/Dense"

using namespace Eigen;

class BasicWithTexture : public DemoBase
{
public:
    BasicWithTexture();
    
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
    GLuint _tex;
};

#endif /* defined(__ShaderPlayground__BasicWithTexture__) */

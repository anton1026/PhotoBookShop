//
//  BlinnPhongPerVert.h
//  ShaderPlayground
//
//  Created by Zhu Wen on 14-5-16.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#ifndef __ShaderPlayground__BlinnPhongPerVert__
#define __ShaderPlayground__BlinnPhongPerVert__

#include "DemoBase.h"
#include "../Eigen/Dense"

using namespace Eigen;

class BlinnPhongPerVert : public DemoBase
{
public:
    BlinnPhongPerVert();
    
    virtual void SetupGL();
    virtual void TearDownGL();
    virtual void Update(const float viewWidth, const float viewHeight, const float time);
    virtual void Render();
private:
    float _rotation;
    
    Matrix4f _matMVP1;
    Matrix3f _matNormal1;

	Affine3f _transView;
    
    Matrix4f _matMVP2;
    Matrix3f _matNormal2;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    
    Shader* _shader;
    GLuint _tex;
    
    Vector3f _lightDir;
};

#endif /* defined(__ShaderPlayground__BlinnPhongPerVert__) */

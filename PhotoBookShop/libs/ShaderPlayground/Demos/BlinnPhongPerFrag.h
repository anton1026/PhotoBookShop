#ifndef __ShaderPlayground__BlinnPhongPerFrag__
#define __ShaderPlayground__BlinnPhongPerFrag__

#include "DemoBase.h"
#include "../Eigen/Dense"

using namespace Eigen;

class BlinnPhongPerFrag : public DemoBase
{
public:
    BlinnPhongPerFrag();
    
    virtual void SetupGL(GLuint _image,bool flg,float aspect);
    virtual void TearDownGL();
    virtual void Update(const float viewWidth, const float viewHeight, const float time,float mouse_X,float mouse_Y);
    virtual void Render();
    virtual void UpdateChange(float ww,float aspect, float ll,bool wrap);
    
private:
   
    float _rotation;
 
    Matrix4f _matMVP1;
    Matrix3f _matNormal1;

	Affine3f _transView;
    
    Matrix4f _matMVP2;
    Matrix3f _matNormal2;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _vertexArray2;
    GLuint _vertexBuffer2;
    
    Shader* _shader;
    GLuint _tex;
    
    Vector3f _lightDir;
};

#endif /* defined(__ShaderPlayground__BlinnPhongPerFrag__) */

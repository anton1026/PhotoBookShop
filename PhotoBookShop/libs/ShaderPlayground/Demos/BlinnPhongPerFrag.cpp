#include "BlinnPhongPerFrag.h"
#include "../Helpers.h"


static unsigned int bananaNumVerts = 36;

BlinnPhongPerFrag::BlinnPhongPerFrag():
_tex(0),
_vertexArray(0),
_vertexBuffer(0),

_shader(NULL),
_rotation(0.f)
{
    demoName = "BlinnPhongPerFrag";
}

void BlinnPhongPerFrag::SetupGL(GLuint _image,bool flg,float aspect)
{
    _shader = ShaderManager::Instance()->GetShader("BlinnPhongPerFrag");
    
 
    
  
    float ww= 0.3f;

    float ll= ww/5.f; _tex = _image;
    UpdateChange(ww, aspect, ll,flg);
   
    DemoBase::SetupGL(_image,flg,aspect);
}
void BlinnPhongPerFrag::UpdateChange(float ww,float aspect, float ll,bool wrap)
{
    float tk= 0.1f;
    float hh= ww/aspect;
    ///TearDownGL();
    float vertex_data[]= {
        
        ww,   hh, ll, 	 -1., -0.0, 0.0, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, ll, 	 -1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f+tk,
        -ww, -hh, ll,    -1., -0.0f, 0.0f,   1.0f-tk, 1.0f-tk,
        -ww, -hh, ll,    -1., -0.0f, 0.0f,   1.0f-tk, 1.0f-tk,
        ww,   hh, ll, 	 -1., -0.0f, 0.0f, 	 0.0f+tk, 0.0f+tk,
        ww,  -hh, ll,    -1., -0.0f, 0.0f,   0.0f+tk, 1.0f-tk,
        
        -ww,  hh, ll, 	 -1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f+tk,
        -ww,  hh, 0, 	 -1., -0.0f, 0.0f, 	 1.0f,    0.0f+tk,
        -ww, -hh,  ll,    -1., -0.0f, 0.0f,  1.0f-tk, 1.0f-tk,
        -ww, -hh,  ll,    -1., -0.0f, 0.0f,	 1.0f-tk, 1.0f-tk,
        -ww,  hh, 0, 	 -1., -0.0f, 0.0f, 	 1.0f,   0.0f+tk,
        -ww, -hh, 0,      -1., -0.0f, 0.0f,  1.0f,   1.0f-tk,
        
        
        
        ww,  hh, ll, 	 -1., -0.0f, 0.0f, 	0.0f+tk, 0.0f+tk,
        ww,  hh, 0, 	 -1., -0.0f, 0.0f, 	0.0f,   0.0f+tk,
        ww, -hh,  ll,    -1., -0.0f, 0.0f, 	0.0f+tk, 1.0f-tk,
        ww, -hh,  ll,    -1., -0.0f, 0.0f, 	0.0f+tk, 1.0f-tk,
        ww,  hh, 0, 	 -1., -0.0f, 0.0f, 	0.0f,    0.0f+tk,
        ww, -hh, 0,      -1., -0.0f, 0.0f, 	0.0f,    1.0f-tk,
        
        
        ww,   hh, 0, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, 0, 	 1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f+tk,
        -ww, -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f-tk,
        -ww, -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f-tk,
        ww,   hh, 0, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        ww,  -hh, 0,     1., -0.0f, 1.0f, 	 0.0f+tk, 1.0f-tk,
        
        ww,   hh, ll, 	 1., -0.0f, 0.0f, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, ll, 	 1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f+tk,
        -ww,  hh, 0,     1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f,
        -ww,  hh, 0,     1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f,
        ww,   hh, ll, 	 1., -0.0f, 0.0f, 	 0.0f+tk, 0.0f+tk,
        ww,   hh, 0,     1., -0.0f, 0.0f, 	 0.0f+tk, 0.0f,
        
        
        ww,   -hh, ll, 	 1., -0.0f, 0.0f, 	 0.0f+tk, 1-tk,
        -ww,  -hh, ll, 	 1., -0.0f, 0.0f, 	 1.0f-tk, 1-tk,
        -ww,  -hh, 0,     1., -0.0f, 0.0f, 	 1.0f-tk, 1.0f,
        -ww,  -hh, 0,     1., -0.0f, 0.0f, 	 1.0f-tk, 1.0f,
        ww,   -hh, ll, 	 1., -0.0f, 0.0f, 	 0.0f+tk, 1.0f,
        ww,   -hh, 0,     1., -0.0f, 0.0f, 	 0.0f+tk, 1.0f-tk,
        
        
    };
    
    
    tk= 0.1f;
    float vertex_data1[]= {
        
        ww,   hh, ll, 	 -1., -0.0, 0.0, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, ll, 	 -1., -0.0f, 0.0f, 	 1.0f-tk, 0.0f+tk,
        -ww, -hh, ll,    -1., -0.0f, 0.0f,   1.0f-tk, 1.0f-tk,
        -ww, -hh, ll,    -1., -0.0f, 0.0f,   1.0f-tk, 1.0f-tk,
        ww,   hh, ll, 	 -1., -0.0f, 0.0f, 	 0.0f+tk, 0.0f+tk,
        ww,  -hh, ll,    -1., -0.0f, 0.0f,   0.0f+tk, 1.0f-tk,
        
        -ww,  hh, ll, 	 -1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f+tk,
        -ww,  hh, 0, 	 -1., -0.0f, 1.0f, 	 1.0f,    0.0f+tk,
        -ww, -hh,  ll,    -1., -0.0f, 1.0f,  1.0f-tk, 1.0f-tk,
        -ww, -hh,  ll,    -1., -0.0f, 1.0f,	 1.0f-tk, 1.0f-tk,
        -ww,  hh, 0, 	 -1., -0.0f, 1.0f, 	 1.0f,   0.0f+tk,
        -ww, -hh, 0,      -1., -0.0f, 1.0f,  1.0f,   1.0f-tk,
        
        
        
        ww,  hh, ll, 	 -1., -0.0f, 1.0f, 	0.0f+tk, 0.0f+tk,
        ww,  hh, 0, 	 -1., -0.0f, 1.0f, 	0.0f,   0.0f+tk,
        ww, -hh,  ll,    -1., -0.0f, 1.0f, 	0.0f+tk, 1.0f-tk,
        ww, -hh,  ll,    -1., -0.0f, 1.0f, 	0.0f+tk, 1.0f-tk,
        ww,  hh, 0, 	 -1., -0.0f, 1.0f, 	0.0f,    0.0f+tk,
        ww, -hh, 0,      -1., -0.0f, 1.0f, 	0.0f,    1.0f-tk,
        
        
        ww,   hh, 0, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, 0, 	 1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f+tk,
        -ww, -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f-tk,
        -ww, -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f-tk,
        ww,   hh, 0, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        ww,  -hh, 0,     1., -0.0f, 1.0f, 	 0.0f+tk, 1.0f-tk,
        
        ww,   hh, ll, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        -ww,  hh, ll, 	 1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f+tk,
        -ww,  hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f,
        -ww,  hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 0.0f,
        ww,   hh, ll, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f+tk,
        ww,   hh, 0,     1., -0.0f, 1.0f, 	 0.0f+tk, 0.0f,
        
        
        ww,   -hh, ll, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 1-tk,
        -ww,  -hh, ll, 	 1., -0.0f, 1.0f, 	 1.0f-tk, 1-tk,
        -ww,  -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f,
        -ww,  -hh, 0,     1., -0.0f, 1.0f, 	 1.0f-tk, 1.0f,
        ww,   -hh, ll, 	 1., -0.0f, 1.0f, 	 0.0f+tk, 1.0f,
        ww,   -hh, 0,     1., -0.0f, 1.0f, 	 0.0f+tk, 1.0f-tk,
        
        
    };
    
    
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    if (wrap==true)
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_data), vertex_data, GL_STATIC_DRAW);
    else
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertex_data1), vertex_data1, GL_STATIC_DRAW);
    glEnableVertexAttribArray(VA_POSITION);
    glVertexAttribPointer(VA_POSITION, 3, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(VA_NORMAL);
    glVertexAttribPointer(VA_NORMAL, 3, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(12));
    
    glEnableVertexAttribArray(VA_TEXCOORD);
    glVertexAttribPointer(VA_TEXCOORD, 2, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
}
void BlinnPhongPerFrag::TearDownGL()
{
	if (isLoaded)
	{
		glDeleteBuffers(1, &_vertexBuffer);
		glDeleteVertexArraysOES(1, &_vertexArray);

		glDeleteTextures(1, &_tex);

		ShaderManager::Instance()->DelShader(_shader);
	}
	
	DemoBase::TearDownGL();
}

void BlinnPhongPerFrag::Update(const float viewWidth, const float viewHeight, const float time,float mouse_X,float mouse_Y)
{
    float aspect = fabsf(viewWidth / viewHeight);

    Matrix4f _matProj = perspective<float>(45.f, aspect, 0.1f, 20.f);
    
    Affine3f _transBase;
    _transBase = Translation3f(0.f, 0.f, 0.f);//*AngleAxis<float>(_rotation, Vector3f(0.f, 1.f, 0.f));
    
    _transView = Translation3f(0.f, 0.f, -1.5f)*AngleAxis<float>(mouse_Y, Vector3f::UnitX())*AngleAxis<float>(mouse_X, Vector3f::UnitY());//*Scaling(1.5f);
    _transView = _transBase*_transView;
    
    _matNormal1 = _transView.matrix().inverse().transpose().topLeftCorner<3, 3>();
    _matMVP1 = _matProj*_transView.matrix();
    

    _lightDir = AngleAxis<float>(_rotation, Vector3f::UnitY())*Vector3f(1.f, 0.5f, 1.f);
    
    _rotation = 9.0+mouse_X;
}

void BlinnPhongPerFrag::Render()
{
    glClearColor(0.8f, 0.8f, 0.8f, 1.0f);
    //glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	// Render the object again with ES2
	glUseProgram(_shader->program);
	//ShaderManager::Instance()->UpdateUniforms(_shader);

    glBindVertexArrayOES(_vertexArray);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _tex);
    glUniform1i(_shader->uniforms[UNIFORM_TEX], 0);
    
    glUniformMatrix4fv(_shader->uniforms[UNIFORM_MVP], 1, 0, _matMVP1.data());
    glUniformMatrix3fv(_shader->uniforms[UNIFORM_NORMAL], 1, 0, _matNormal1.data());
    glUniform3fv(_shader->uniforms[UNIFORM_LIGHTDIR], 1, _lightDir.data());
	glUniformMatrix4fv(_shader->uniforms[UNIFORM_MV], 1, 0, _transView.matrix().data());
    
    glDrawArrays(GL_TRIANGLES, 0, bananaNumVerts);
    

}

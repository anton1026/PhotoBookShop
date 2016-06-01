//
//  BasicWithFullColor.cpp
//  ShaderPlayground
//
//  Created by K-Res on 14-5-12.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#include "BasicWithFullColor.h"
#include "../Helpers.h"

#include "../Resources/cube.h"

BasicWithFullColor::BasicWithFullColor():
_vertexArray(0),
_vertexBuffer(0),
_shader(NULL),
_rotation(0.f)
{
    demoName = "BasicWithFullColor";
}

void BasicWithFullColor::SetupGL()
{
    _shader = ShaderManager::Instance()->GetShader("BasicWithFullColor");
    
    _color[0] = 1.f;
    _color[1] = 0.5f;
    _color[2] = 0.f;
    _color[3] = 1.f;
    
    _colorStep[0] = 0.01f;
    _colorStep[1] = 0.01f;
    _colorStep[2] = 0.01f;
    
    glEnable(GL_DEPTH_TEST);

    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(cubeVertexData), cubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(VA_POSITION);
    glVertexAttribPointer(VA_POSITION, 3, GL_FLOAT, GL_TRUE, 24, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(VA_NORMAL);
    glVertexAttribPointer(VA_NORMAL, 3, GL_FLOAT, GL_TRUE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);

	DemoBase::SetupGL();
}

void BasicWithFullColor::TearDownGL()
{
	if (isLoaded)
	{
		glDeleteBuffers(1, &_vertexBuffer);
		glDeleteVertexArraysOES(1, &_vertexArray);

		//ShaderManager::Instance()->DelShader(_shader);
	}

	DemoBase::TearDownGL();
}

void BasicWithFullColor::Update(const float viewWidth, const float viewHeight, const float time)
{
    float aspect = fabsf(viewWidth / viewHeight);
    
    Matrix4f _matProj = perspective<float>(65.f, aspect, 0.1f, 100.f);
    
    Affine3f _transBase;
    _transBase = Translation3f(0.f, 0.f, -4.f)*AngleAxis<float>(_rotation, Vector3f(0.f, 1.f, 0.f));
    
    Affine3f _transView;
    Vector3f axis(1.f, 1.f, 1.f);
    axis.normalize();
    
    _transView = Translation3f(0.f, 0.f, -1.5f)*AngleAxis<float>(_rotation, axis);
    _transView = _transBase*_transView;
    
    _matNormal1 = _transView.matrix().inverse().transpose().topLeftCorner<3, 3>();
    _matMVP1 = _matProj*_transView.matrix();
    
    _transView = Translation3f(0.f, 0.f, 1.5f)*AngleAxis<float>(_rotation, axis);
    _transView = _transBase*_transView;
    
    _matNormal2 = _transView.matrix().inverse().transpose().topLeftCorner<3, 3>();
    _matMVP2 = _matProj*_transView.matrix();
    
    _rotation += time * 0.35f;
    
    for (int i=0;i<3;i++)
    {
        _color[i] += _colorStep[i];
        if (_color[i]>1.f||_color[i]<0.f)
        {
            _colorStep[i] *= -1.f;
            _color[i] += _colorStep[i];
        }
    }
}

void BasicWithFullColor::Render()
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object again with ES2
    glUseProgram(_shader->program);
    
    glUniformMatrix4fv(_shader->uniforms[UNIFORM_MVP], 1, 0, _matMVP1.data());
    glUniformMatrix3fv(_shader->uniforms[UNIFORM_NORMAL], 1, 0, _matNormal1.data());
    
    glUniform4fv(_shader->uniforms[UNIFORM_FULLCOLOR], 1, _color);
    
    glDrawArrays(GL_TRIANGLES, 0, cubeNumVerts);
    
    glUniformMatrix4fv(_shader->uniforms[UNIFORM_MVP], 1, 0, _matMVP2.data());
    glUniformMatrix3fv(_shader->uniforms[UNIFORM_NORMAL], 1, 0, _matNormal2.data());
    
    //    glUniform4fv(_shader->uniforms[UNIFORM_FULLCOLOR], 1, _color);
    glUniform4f(_shader->uniforms[UNIFORM_FULLCOLOR], _color[1], _color[2], _color[3], _color[0]);
    
    glDrawArrays(GL_TRIANGLES, 0, cubeNumVerts);
}

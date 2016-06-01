//
//  BasicWithTexture.cpp
//  ShaderPlayground
//
//  Created by Zhu Wen on 14-5-13.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#include "BasicWithTexture.h"
#include "../Helpers.h"

#include "../Resources/banana.h"

BasicWithTexture::BasicWithTexture():
_tex(0),
_vertexArray(0),
_vertexBuffer(0),
_shader(NULL),
_rotation(0.f)
{
    demoName = "BasicWithTexture";
}

void BasicWithTexture::SetupGL()
{
    _shader = ShaderManager::Instance()->GetShader("BasicWithTexture");
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(bananaVertexData), bananaVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(VA_POSITION);
    glVertexAttribPointer(VA_POSITION, 3, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(VA_NORMAL);
    glVertexAttribPointer(VA_NORMAL, 3, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(12));
    
    glEnableVertexAttribArray(VA_TEXCOORD);
    glVertexAttribPointer(VA_TEXCOORD, 2, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
    
    _tex = LoadGLTexture("banana.jpg");

	DemoBase::SetupGL();
}

void BasicWithTexture::TearDownGL()
{
	if (isLoaded)
	{
		glDeleteBuffers(1, &_vertexBuffer);
		glDeleteVertexArraysOES(1, &_vertexArray);

		glDeleteTextures(1, &_tex);

		//ShaderManager::Instance()->DelShader(_shader);
	}

	DemoBase::TearDownGL();
}

void BasicWithTexture::Update(const float viewWidth, const float viewHeight, const float time)
{
	// LOGI("BasicWithTexture update: %f rot: %f", time, _rotation);
    float aspect = fabsf(viewWidth / viewHeight);
    
    Matrix4f _matProj = perspective<float>(65.f, aspect, 0.1f, 100.f);
    
    Affine3f _transBase;
    _transBase = Translation3f(0.f, 0.f, -4.f)*AngleAxis<float>(_rotation, Vector3f(0.f, 1.f, 0.f));
    
    Affine3f _transView;
    Vector3f axis(1.f, 1.f, 1.f);
    axis.normalize();
    
    _transView = Translation3f(0.f, 0.f, -1.5f)*AngleAxis<float>(_rotation, axis)*Scaling(2.f);
    _transView = _transBase*_transView;
    
    _matNormal1 = _transView.matrix().inverse().transpose().topLeftCorner<3, 3>();
    _matMVP1 = _matProj*_transView.matrix();
    
    _transView = Translation3f(0.f, 0.f, 1.5f)*AngleAxis<float>(_rotation, axis)*Scaling(2.f);
    _transView = _transBase*_transView;
    
    _matNormal2 = _transView.matrix().inverse().transpose().topLeftCorner<3, 3>();
    _matMVP2 = _matProj*_transView.matrix();
    
    _rotation += time;
}

void BasicWithTexture::Render()
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
	// Render the object again with ES2
	glUseProgram(_shader->program);

    glBindVertexArrayOES(_vertexArray);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _tex);
    glUniform1i(_shader->uniforms[UNIFORM_TEX], 0);
    
    glUniformMatrix4fv(_shader->uniforms[UNIFORM_MVP], 1, 0, _matMVP1.data());
    glUniformMatrix3fv(_shader->uniforms[UNIFORM_NORMAL], 1, 0, _matNormal1.data());
    
    glDrawArrays(GL_TRIANGLES, 0, bananaNumVerts);
    
    glUniformMatrix4fv(_shader->uniforms[UNIFORM_MVP], 1, 0, _matMVP2.data());
    glUniformMatrix3fv(_shader->uniforms[UNIFORM_NORMAL], 1, 0, _matNormal2.data());
    
    glDrawArrays(GL_TRIANGLES, 0, bananaNumVerts);
}

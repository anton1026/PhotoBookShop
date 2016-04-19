//
//  ShaderManager.h
//  ShaderPlayground
//
//  Created by K-Res on 14-5-6.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#ifndef __ShaderPlayground__ShaderManager__
#define __ShaderPlayground__ShaderManager__

#include <OpenGLES/ES2/gl.h>

#include <map>
#include <string>

using namespace std;

// Vertex attributes index.
enum VertexAttributes
{
    VA_POSITION,
    VA_NORMAL,
    VA_TEXCOORD
};

// Uniform index.
enum
{
    UNIFORM_MVP,
    UNIFORM_NORMAL,
    UNIFORM_FULLCOLOR,
    UNIFORM_TEX,
    UNIFORM_LIGHTDIR,
	UNIFORM_MV,
    NUM_UNIFORMS_COUNT
};

// Shader data structer.
struct Shader
{
    string name;
    GLuint program;
    GLint uniforms[NUM_UNIFORMS_COUNT];
};

// Manages using of shaders.
class ShaderManager
{
private:
    static ShaderManager* sharedInstance;
public:
    static ShaderManager* Instance();
public:
    Shader* GetShader(const string shaderName);
    void DelShader(Shader*& shader);
	void RemoveAllShaders();
	void UpdateUniforms(Shader* shader);
private:
    ShaderManager();
    Shader* LoadShader(const string shaderName);
	bool CompileShader(GLuint* shader, GLenum type, const string file);
    bool LinkProgram(GLuint prog);
    bool ValidateProgram(GLuint prog);
    void RemoveShader(const string shaderName);
private:
    // All loaded shaders.
    map<string, Shader> loadedShaders;
};


#endif /* defined(__ShaderPlayground__ShaderManager__) */

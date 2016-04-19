//
//  ShaderManager.cpp
//  ShaderPlayground
//
//  Created by K-Res on 14-5-6.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#include "ShaderManager.h"
#include "Helpers.h"

#include <stdio.h>
#include <vector>

ShaderManager* ShaderManager::sharedInstance = NULL;

ShaderManager* ShaderManager::Instance()
{
    if (!ShaderManager::sharedInstance)
    {
        ShaderManager::sharedInstance = new ShaderManager();
    }
    
    return ShaderManager::sharedInstance;
}

ShaderManager::ShaderManager()
{
    LOGI("ShaderManager constructed!");
}

Shader* ShaderManager::GetShader(const string shaderName)
{
    map<string, Shader>::iterator it;
    it = loadedShaders.find(shaderName);
    
    if (it!=loadedShaders.end())
    {
        return &(it->second);
    }
    else
    {
        return LoadShader(shaderName);
    }
}

void ShaderManager::DelShader(Shader *&shader)
{
    glDeleteProgram(shader->program);
    shader->program = 0;
    RemoveShader(shader->name);
    shader = NULL;
}

void ShaderManager::RemoveShader(const string shaderName)
{
    map<string, Shader>::iterator it;
    it = loadedShaders.find(shaderName);
    
    if (it!=loadedShaders.end())
    {
        loadedShaders.erase(it);
    }
}

Shader* ShaderManager::LoadShader(const string shaderName)
{
    string vshFile = GetResourceFile(shaderName+".vsh");
    string fshFile = GetResourceFile(shaderName+".fsh");
    
    //    LOGI("vsh: %s", vshFile.c_str());
    //    LOGI("fsh: %s", fshFile.c_str());
    LOGI("Loading shader: %s", shaderName.c_str());
    
    if (""==vshFile||""==fshFile)
    {
        LOGE("Can't find v or f shader!");
        return NULL;
    }
    
    GLuint vertShader, fragShader;
    
    Shader shader;
    shader.program = glCreateProgram();
    shader.name = shaderName;
    
    if (!CompileShader(&vertShader, GL_VERTEX_SHADER, vshFile))
    {
        LOGE("Failed to compile vertex shader!");
        //        glDeleteProgram(shader.program);
        return NULL;
    }
    
    if (!CompileShader(&fragShader, GL_FRAGMENT_SHADER, fshFile))
    {
        LOGE("Failed to compile fragment shader!");
        //        glDeleteProgram(shader.program);
        return NULL;
    }
    
    glAttachShader(shader.program, vertShader);
    glAttachShader(shader.program, fragShader);
    
    glBindAttribLocation(shader.program, VA_POSITION, "position");
    glBindAttribLocation(shader.program, VA_NORMAL, "normal");
    glBindAttribLocation(shader.program, VA_TEXCOORD, "texcoord");
    
    // Link program.
    if (!LinkProgram(shader.program))
    {
        LOGE("Failed to link program: %d", shader.program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (shader.program)
        {
            glDeleteProgram(shader.program);
            shader.program = 0;
        }
        
        return NULL;
    }
    
    // Find all available vertex attributes.
    /*
     GLint maxAttribNameLength = 0;
     glGetProgramiv(shader.program, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &maxAttribNameLength);
     vector<GLchar> nameData(maxAttribNameLength);
     
     for(int attrib = 0; attrib < maxAttribNameLength; ++attrib)
     {
     GLint arraySize = 0;
     GLenum type = 0;
     GLsizei actualLength = 0;
     glGetActiveAttrib(shader.program, attrib, nameData.size(), &actualLength, &arraySize, &type, &nameData[0]);
     std::string name((char*)&nameData[0], actualLength);
     }
     */
    
	UpdateUniforms(&shader);
    
    
    if (vertShader)
    {
        glDetachShader(shader.program, vertShader);
        glDeleteShader(vertShader);
    }
    
    if (fragShader)
    {
        glDetachShader(shader.program, fragShader);
        glDeleteShader(fragShader);
    }
    
    loadedShaders.insert(map<string, Shader>::value_type(shaderName, shader));
    LOGI("Shader: %s loaded!", shaderName.c_str());
    return GetShader(shaderName);
}

bool ShaderManager::CompileShader(GLuint *shader, GLenum type, const string file)
{
	LOGI("Compiling shader: %s", file.c_str());
    GLint status;
    string source = "";
    
    source = ReadFile(file);
    if (""==source)
    {
        LOGE("Failed to read shader source file!");
        return false;
    }
    
    *shader = glCreateShader(type);
    GLchar* src = (GLchar*)source.c_str();
    glShaderSource(*shader, 1, (const char**)&src, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength>0)
    {
        GLchar* log = (GLchar*)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        LOGI("Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (0==status)
    {
        glDeleteShader(*shader);
        return false;
    }
    
    return true;
}

bool ShaderManager::LinkProgram(GLuint prog)
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength>0)
    {
        GLchar* log = (GLchar*)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        LOGI("Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (0==status)
        return false;
    
    return true;
}

bool ShaderManager::ValidateProgram(GLuint prog)
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength>0)
    {
        GLchar* log = (GLchar*)malloc(logLength);
        glGetShaderInfoLog(prog, logLength, &logLength, log);
        LOGI("Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    // Need to clear gl error flag.
    glGetError();
    if (0==status)
        return false;
    
    return true;
}

void ShaderManager::RemoveAllShaders()
{
	loadedShaders.clear();
}

void ShaderManager::UpdateUniforms(Shader* shader)
{
	// Get uniform locations.
	shader->uniforms[UNIFORM_MVP] = glGetUniformLocation(shader->program, "modelViewProjectionMatrix");
	shader->uniforms[UNIFORM_NORMAL] = glGetUniformLocation(shader->program, "normalMatrix");
	shader->uniforms[UNIFORM_FULLCOLOR] = glGetUniformLocation(shader->program, "fullColor");
	shader->uniforms[UNIFORM_TEX] = glGetUniformLocation(shader->program, "texture");
	shader->uniforms[UNIFORM_LIGHTDIR] = glGetUniformLocation(shader->program, "lightDir");
	shader->uniforms[UNIFORM_MV] = glGetUniformLocation(shader->program, "modelViewMatrix");
}

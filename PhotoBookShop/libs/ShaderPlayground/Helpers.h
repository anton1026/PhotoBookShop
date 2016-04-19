//
//  Helpers.h
//  ShaderPlayground
//
//  Created by K-Res on 14-5-6.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#ifndef __ShaderPlayground__Helpers__
#define __ShaderPlayground__Helpers__

#include <math.h>
#include <string>

#include "Eigen/Core"
#include <OpenGLES/ES2/gl.h>

using namespace Eigen;
using namespace std;

inline float RadToDeg(float radians)
{
    return radians*(180.f/M_PI);
}

inline float DegToRad(float degrees)
{
    return degrees*(M_PI/180.f);
}

template<class T> Matrix<T,4,4> perspective(float fovy,
                                            float aspect,
                                            float zNear,
                                            float zFar)
{
    typedef Matrix<T,4,4> Matrix4;
    
    assert(aspect>0);
    assert(zFar>zNear);
    
    float radf = DegToRad(fovy);
    
    float tanHalfFovy = tanf(radf/2.f);
    Matrix4 res = Matrix4::Zero();
    res(0,0) = 1.0/(aspect * tanHalfFovy);
    res(1,1) = 1.0/(tanHalfFovy);
    res(2,2) = - (zFar + zNear)/(zFar - zNear);
    res(3,2) = - 1.0;
    res(2,3) = - (2.0 * zFar * zNear)/(zFar - zNear);
    
    return res;
}

template<class T> Matrix<T,4,4> lookAt(Matrix<T,3,1> const& eye,
                                        Matrix<T,3,1> const& center,
                                        Matrix<T,3,1> const& up)
{
    typedef Matrix<T,4,4> Matrix4;
    typedef Matrix<T,3,1> Vector3;
    
    Vector3 f = (center - eye).normalized();
    Vector3 u = up.normalized();
    Vector3 s = f.cross(u).normalized();
    u = s.cross(f);
    
    Matrix4 res;
    res << s.x(), s.y(), s.z(), -s.dot(eye),
            u.x(), u.y(), u.z(), -u.dot(eye),
            -f.x(), -f.y(), -f.z(), f.dot(eye),
            0, 0, 0, 1;
    
    return res;
}

// Load image and generate OpenGL texture using Quartz 2D api.

// Find resource file's full path.
string GetResourceFile(const string fileName);
// Read contents from specific file.
string ReadFile(const string fileName);

#ifdef DEBUG

#define LOGI(format, ...) KLOGI(format, ## __VA_ARGS__)
#define LOGW(format, ...) KLOGW(format, ## __VA_ARGS__)
#define LOGE(format, ...) KLOGE(format, ## __VA_ARGS__)
#define CLog(format, ...) NSLog(format, ## __VA_ARGS__)

#else

#define LOGI(format, ...)
#define LOGW(format, ...)
#define LOGE(format, ...)
#define CLog(format, ...)

#endif

void KLOGI(char const* szFmt,...);
void KLOGW(char const* szFmt,...);
void KLOGE(char const* szFmt,...);

#endif /* defined(__ShaderPlayground__Helpers__) */

#ifndef __ShaderPlayground__DemoBase__
#define __ShaderPlayground__DemoBase__

#include "../ShaderManager.h"

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <string>

using namespace std;

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

class DemoBase
{
public:
    DemoBase();
    virtual ~DemoBase() {}
    // Initialization.
    virtual void SetupGL(GLuint _image,bool flg,float aspect);
    
    // Release.
    virtual void TearDownGL();
    // Update logic.
    virtual void Update(const float viewWidth, const float viewHeight, const float time,float mouse_X,float mouse_Y) = 0;
    virtual void UpdateChange(float ww,float aspect, float ll,bool wrap)=0;
    // Render process.
    virtual void Render() = 0;
public:
    // Name of this demo.
    string demoName;
    bool isLoaded;
protected:
	
};

#endif /* defined(__ShaderPlayground__DemoBase__) */

#include "DemoBase.h"
#include "Helpers.h"

DemoBase::DemoBase():
isLoaded(false)
{
}

void DemoBase::SetupGL(GLuint _image,bool flg,float aspect)
{
	isLoaded = true;
}

void DemoBase::TearDownGL()
{
	isLoaded = false;
}

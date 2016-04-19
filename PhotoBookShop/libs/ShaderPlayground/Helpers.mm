//
//  Helpers.cpp
//  ShaderPlayground
//
//  Created by K-Res on 14-5-6.
//  Copyright (c) 2014年 K-Res. All rights reserved.
//

#include "Helpers.h"

static const int MAX_LOGBUF = 1024;

string GetResourceFile(const string fileName)
{
	NSString *name = [[NSString alloc] initWithUTF8String:fileName.c_str()];
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil inDirectory:nil];
	
    if (path)
    {
        return [path UTF8String];
    }
    else
    {
        return "";
    }
}

string ReadFile(const string fileName)
{
    NSString* contents = [NSString stringWithContentsOfFile:[NSString stringWithUTF8String:fileName.c_str()]
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    if (nil==contents)
        return "";
    else
        return [contents UTF8String];
}

void KLOGI(char const* szFmt,...)
{
	char szBuf[MAX_LOGBUF];
	va_list argptr;
	va_start(argptr, szFmt);
	vsprintf(szBuf, szFmt, argptr);
	va_end(argptr);
    
	NSLog(@"<I>:%s\n",szBuf);
}

void KLOGW(char const* szFmt,...)
{
	char szBuf[MAX_LOGBUF];
	va_list argptr;
	va_start(argptr, szFmt);
	vsprintf(szBuf, szFmt, argptr);
	va_end(argptr);
	
	NSLog(@"<W>:%s\n",szBuf);
}

void KLOGE(char const* szFmt,...)
{
	char szBuf[MAX_LOGBUF];
	va_list argptr;
	va_start(argptr, szFmt);
	vsprintf(szBuf, szFmt, argptr);
	va_end(argptr);
	
	NSLog(@"<E>:%s\n",szBuf);
}

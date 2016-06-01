//
//  Utilities.m
//  LeavesExamples
//
//  Created by Tom Brow on 4/19/10.
//  Copyright 2010 Tom Brow. All rights reserved.
//
#import "Utilities.h"
CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) {
    CGFloat scaleFactor = 0.0f;
    if (outerRect.size.width/innerRect.size.width > outerRect.size.height/innerRect.size.height) {
         scaleFactor = outerRect.size.height/innerRect.size.height;
    }else{
        scaleFactor = outerRect.size.width/innerRect.size.width;
    }
//	CGFloat scaleFactor = (CGFloat)MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x,
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}

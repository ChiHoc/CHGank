//
//  CHUtils.h
//  CHGank
//
//  Created by ChiHo on 7/13/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#ifndef CHUtils_h
#define CHUtils_h

#import <CoreGraphics/CGGeometry.h>

CG_INLINE float
CGRectLeft(CGRect rect)
{
    return rect.origin.x;
}

CG_INLINE float
CGRectTop(CGRect rect)
{
    return rect.origin.y;
}

CG_INLINE float
CGRectRight(CGRect rect)
{
    return rect.origin.x + rect.size.width;
}

CG_INLINE float
CGRectBottom(CGRect rect)
{
    return rect.origin.y + rect.size.height;
}

CG_INLINE float
CGRectWidth(CGRect rect)
{
    return rect.size.width;
}

CG_INLINE float
CGRectHeight(CGRect rect)
{
    return rect.size.height;
}

CG_INLINE CGPoint
CGRectCenter(CGRect rect)
{
    CGPoint point;
    point.x = rect.origin.x + (rect.size.width)/2;
    point.y = rect.origin.y + (rect.size.height)/2;
    return point;
}

CG_INLINE float
CGRectCenterX(CGRect rect, float width)
{
    return rect.origin.x + (rect.size.width - width)/2;
}

CG_INLINE float
CGRectCenterY(CGRect rect, float height)
{
    return rect.origin.y + (rect.size.height - height)/2;
}

CG_INLINE float
CGRectWithinCenterX(CGRect rect, float width)
{
    return (rect.size.width - width)/2;
}

CG_INLINE float
CGRectWithinCenterY(CGRect rect, float height)
{
    return (rect.size.height - height)/2;
}

#pragma mark - 转换横竖向坐标
CG_INLINE CGRect
CGRectSwitchOrientation(CGRect rect)
{
    return CGRectMake(rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
}

CG_INLINE BOOL
isLandscapeOrientation()
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(orientation);
    
    return (isLandscape && iOS8AndLater == NO) || iOS6AndLater == NO;
}

CG_INLINE CGFloat
screenWidth()
{
    if (isLandscapeOrientation() == NO) {
        return CGRectWidth([[UIScreen mainScreen] bounds]);
    } else {
        return CGRectHeight([[UIScreen mainScreen] bounds]);
    }
}

CG_INLINE CGFloat
screenHeight()
{
    if (isLandscapeOrientation() == NO) {
        return CGRectHeight([[UIScreen mainScreen] bounds]);
    } else {
        return CGRectWidth([[UIScreen mainScreen] bounds]);
    }
}

CG_INLINE CGRect
windowBounds()
{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    if (isLandscapeOrientation() == NO) {
        return [window bounds];
    } else {
        return CGRectSwitchOrientation([window bounds]);
    }
}

CG_INLINE CGFloat
windowWidth()
{
    return windowBounds().size.width;
}

CG_INLINE CGFloat
windowHeight()
{
    return windowBounds().size.height;
}

CG_INLINE
void RUN_ON_UI_THREAD(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

#endif /* CHUtils_h */

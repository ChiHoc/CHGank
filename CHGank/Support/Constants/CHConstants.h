//
//  CHConstants.h
//  CHConstants
//
//  Created by ChiHo on 6/2/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#ifndef CHConstants_h
#define CHConstants_h

#define LS(key) NSLocalizedString(key, nil)

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE_4     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5     (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6     (fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)375) < DBL_EPSILON)
#define IS_IPHONE_6P     (fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)414) < DBL_EPSILON)

#define iOS6AndLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define iOS7AndLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS8AndLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define iOS9AndLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define RGB(r, g, b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define APP_DELEGATE    ((GKAppDelegate *)[[UIApplication sharedApplication] delegate])

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define NSStringFromVariable(variable) [NSString stringWithFormat:@"%s", #variable]

#define STRETCHABLE_IMAGE(imageName, w, h) [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:w topCapHeight:h]

//UserDefaults
#define DEFAULTS(type, key) ([[NSUserDefaults standardUserDefaults] type##ForKey:key])
#define SET_DEFAULTS(Type, key, val) do {                               \
[[NSUserDefaults standardUserDefaults] set##Type:val forKey:key];   \
[[NSUserDefaults standardUserDefaults] synchronize];                \
} while (0)
#define RM_DEFAULTS(key) do {                                           \
[[NSUserDefaults standardUserDefaults] removeObjectForKey:key];     \
[[NSUserDefaults standardUserDefaults] synchronize];                \
} while (0)

#endif /* CHConstants_h */

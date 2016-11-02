//
//  CHLogConstants.h
//  CHConstants
//
//  Created by ChiHo on 6/2/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#ifndef CHLogConstants_h
#define CHLogConstants_h

#if DEBUG

#define CHLOG(format, ...) NSLog(format, ##__VA_ARGS__)
#define CHBEGIN()    do { NSLog(@"=> %s\n", __PRETTY_FUNCTION__); } while(0)

#else

#define CHLOG(...)
#define CHBEGIN()

#endif


#define CHLogLocation() do {CHLOG(@"File: %s \nFunc: %s \nLine: %u\n", __FILE__, __PRETTY_FUNCTION__, __LINE__); } while(0)
//#define CHLogLocation() do {CHLOG(@"File: %s \nFunc: %s \nLine: %u\n", __FILE__, __PRETTY_FUNCTION__, __LINE__); [g_pCHLog addLine:@"Error Occured!"]; [g_pCHLog addLine:[NSString stringWithFormat:@"File: %s \nFunc: %s \nLine: %u\n", __FILE__, __PRETTY_FUNCTION__, __LINE__]]; } while(0)


#define CHLogDurationBegin NSTimeInterval st = [[NSDate date] timeIntervalSince1970];
#define CHLogDurationEnd(action) CHLOG(@"%@ duration=%f", action,([[NSDate date] timeIntervalSince1970]-st));st = [[NSDate date] timeIntervalSince1970];

#define CHLogError() do { CHLOG(@"Error Occured!\n"); CHLogLocation(); } while (0)

#define CHECK(a) do { if (!(a)) { CHLogError(); return; } } while (0)
#define CHECKU(a) do { if (!(a)) { CHLogError(); return 0; } } while (0)
#define CHECKN(a) do { if (!(a)) { CHLogError(); return -1; }; } while (0)
#define CHECKP(a) do { if (!(a)) { CHLogError(); return nil; }; } while (0)
#define CHECKB(a) do { if (!(a)) { CHLogError(); return NO; }; } while (0)
#define CHECKYES(a) do { if (!(a)) { CHLogError(); return YES; }; } while (0)

#define CHECK_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return; } } while (0)
#define CHECKU_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return 0; } } while (0)
#define CHECKN_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return -1; } } while (0)
#define CHECKP_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return nil; } } while (0)
#define CHECKB_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return NO; } } while (0)
#define CHECKYES_RESPONDS(obj, selector) do { if (![(obj) respondsToSelector:(selector)]) { CHLogError(); CHLOG(@"obj:%@ selector:%@", [(obj) class], NSStringFromSelector(selector)); return YES; } } while (0)

#endif /* CHLogConstants_h */

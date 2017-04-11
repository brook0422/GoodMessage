//
//  HXVideoLifeCycle.m
//  HXVideoLib
//
//  Created by liuchunhua on 16/10/20.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import "HXVideoLifeCycle.h"
#import "AnyChatPlatform.h"

@implementation HXVideoLifeCycle
+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        
    }
    return self;
}

#pragma mark - **** life cycle
- (void)appDidBecomeActive {
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_CORESDK_ACTIVESTATE :1];
}

- (void)appWillEnterForeground {
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_CORESDK_ACTIVESTATE :1];
}

- (void)appWillResignActive {
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_CORESDK_ACTIVESTATE :0];
}

- (void)appDidEnterBackground {
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_CORESDK_ACTIVESTATE :0];
}

@end

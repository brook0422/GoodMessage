//
//  HXVideoLifeCycle.h
//  HXVideoLib
//
//  Created by liuchunhua on 16/10/20.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXVideoLifeCycle : NSObject
+ (id)sharedManager;

- (void)appDidBecomeActive;

- (void)appWillEnterForeground;

- (void)appWillResignActive;

- (void)appDidEnterBackground;

@end

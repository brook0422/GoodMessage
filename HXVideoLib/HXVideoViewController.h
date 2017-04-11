//
//  HXVideoViewController.h
//  HXVideoSDK
//
//  Created by liuchunhua on 16/10/16.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "AnyChatPlatform.h"

@interface HXVideoViewController : UIViewController
@property (strong, nonatomic)  AVCaptureVideoPreviewLayer    *localVideoSurface;
@property (strong, nonatomic)  UIImageView                   *remoteVideoSurface;
@property (strong, nonatomic)  UIView                        *theLocalView;
@property (strong, nonatomic)  UIImageView                   *imageView;
@property int iRemoteUserId;
- (void) FinishVideoChat;
- (void) FinishVideo;
@end

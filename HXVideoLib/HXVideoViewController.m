//
//  HXVideoViewController.m
//  HXVideoSDK
//
//  Created by liuchunhua on 16/10/16.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import "HXVideoViewController.h"
#import "MZTimerLabel.h"
#define kSelfView_Width                     self.view.frame.size.width
#define kSelfView_Height                    self.view.frame.size.height
#define kLocalVideo_Width                   (kSelfView_Width/375.0f)*100.0f
#define kLocalVideo_Height                  (kSelfView_Height/667.0f)*161.0f
#define kBar_Height                         30.0f
#define kOffSet                             15.0f

#define kLocalVideoPortrait_CGRect          CGRectMake((kSelfView_Width-kOffSet-kLocalVideo_Width), kOffSet, kLocalVideo_Width,kLocalVideo_Height)

#define kImageWidth    60.0f

@interface HXVideoViewController ()<UIAlertViewDelegate>{
    UILabel *_timerLabel;
    NSTimer *timer;
    UILabel *sxLabel,*xxLabel;
    MZTimerLabel *_theVideoMZTimer;
}
@end

@implementation HXVideoViewController
@synthesize iRemoteUserId;
@synthesize remoteVideoSurface;
@synthesize localVideoSurface;
@synthesize theLocalView;
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self StartVideoChat:self.iRemoteUserId];
}

#pragma mark self
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setUIControls];
    [self setTimerLabel];
    [_theVideoMZTimer start];
    [self StartRemoteVideoChat:self.iRemoteUserId];
}

-(void)setTimerLabel{
    CGRect timerRct = CGRectMake(0, kSelfView_Height - 142, kSelfView_Width, 22);
    _timerLabel = [[UILabel alloc] initWithFrame:timerRct];
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.backgroundColor = [UIColor clearColor];
    _timerLabel.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:_timerLabel];
    _theVideoMZTimer = [[MZTimerLabel alloc]initWithLabel:_timerLabel];
    _theVideoMZTimer.timeFormat = @"HH:mm:ss";

}

#pragma mark - Instance Method
- (void) StartVideoChat:(int) userid
{
    //Get a camera, Must be in the real machine.
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if (cameraDeviceArray.count > 0)
    {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:1]];
    }
    // open local video
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:-1 : YES];
    
}

-(void) StartRemoteVideoChat:(int) userid{
    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform SetVideoPos:userid: self.remoteVideoSurface:0:0:0:0];
    [AnyChatPlatform UserCameraControl:userid : YES];
    
    self.iRemoteUserId = userid;
    //远程视频显示时随设备的方向改变而旋转（参数为int型， 0表示关闭， 1 开启[默认]，视频旋转时需要参考本地视频设备方向参数）
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION : self.interfaceOrientation];
}

- (void) FinishVideoChat
{
    [_theVideoMZTimer pause];
    // 关闭摄像头
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    
    [AnyChatPlatform UserSpeakControl: self.iRemoteUserId : NO];
    [AnyChatPlatform UserCameraControl: self.iRemoteUserId : NO];
    
    [AnyChatPlatform LeaveRoom:-1];
    [AnyChatPlatform Logout];
    self.iRemoteUserId = -1;
}

- (void) OnLocalVideoRelease:(id)sender
{
    if (self.localVideoSurface) {
        self.localVideoSurface = nil;
    }
}

- (void) OnLocalVideoInit:(id)session
{
    self.localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession: (AVCaptureSession*)session];
    self.localVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.theLocalView.layer addSublayer:self.localVideoSurface];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)setUIControls
{
    theLocalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSelfView_Width, kSelfView_Height)];
    theLocalView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:theLocalView];
    
    remoteVideoSurface = [[UIImageView alloc] initWithFrame:kLocalVideoPortrait_CGRect];
    [self.view addSubview:remoteVideoSurface];
    remoteVideoSurface.layer.borderColor = [[UIColor whiteColor] CGColor];
    remoteVideoSurface.layer.borderWidth = 1.0f;
    //Rounded corners
    remoteVideoSurface.layer.cornerRadius = 4;
    remoteVideoSurface.layer.masksToBounds = YES;
    
    //disable the “idle timer” to avert system sleep.
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    NSString *imageName = @"hangUp.png";
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setFrame:CGRectMake((kSelfView_Width - kImageWidth)/2.0, kSelfView_Height - kImageWidth - kImageWidth/2.0, kImageWidth, kImageWidth)];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeClick)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapRecognizer];
    [self.view addSubview:imageView];
}

- (void)FinishVideo {
    [self FinishVideoChat];
}

-(void)closeClick{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您确定要退出视频吗"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        
    }else if (buttonIndex == 1){
        [self FinishVideo];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"USERHANGUPEVENT" object:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
@end

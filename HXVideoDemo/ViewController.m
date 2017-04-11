//
//  ViewController.m
//  HXVideoDemo
//
//  Created by liuchunhua on 16/10/16.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import "ViewController.h"
#import <HXVideoLib/HXVideoViewController.h>
@interface ViewController ()<HXVideNotifyMessageDelegate>{
    int _theUserId;
    HXVideoLib *_lib;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _lib = [HXVideoLib getInstance];
    _lib.anyChatMessageDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnUserHangUpEvent) name:@"USERHANGUPEVENT" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login:(id)sender {
    NSDictionary *dic = @{@"anyChatStreamIpOut": _ipText.text,
                          @"anyChatStreamPort": _portText.text,
                          @"userName": _userIdText.text,
                          @"loginPwd": _userPwdText.text,
                          @"roomId": _roomIdText.text,
                          @"roomPwd": _roomPwdText.text,
                          @"remoteId":@""};
    [_lib start:dic];
}

#pragma mark  HXVideNotifyMessageDelegate
// 连接服务器消息
- (void) OnChatConnect:(BOOL)bSuccess{
    NSString *message ;
    if (bSuccess){
        message = @"成功";
        [self.loginBtn setTitle:@"登录成功" forState:UIControlStateNormal];
    }else {
        message = @"失败";
         [self.loginBtn setTitle:@"登录失败" forState:UIControlStateNormal];
    }
    _logView.text = [NSString stringWithFormat:@"连接%@",message];
}

// 当前用户登陆消息
-(void)OnChatLogin:(int)dwUserId :(int)dwErrorCode{
    NSString *message ;
    if (dwErrorCode == 0){
        message = @"成功";
        _theUserId = dwUserId;
    }else {
        message = @"失败";
    }
    _logView.text = [NSString stringWithFormat:@"当前用户%d登录%@",dwUserId,message];
}

// 当前用户进入房间消息
-(void)OnChatEnterRoom:(int)dwRoomId :(int)dwErrorCode{
    NSString *message ;
    if (dwErrorCode == 0){
        message = @"成功";
    }else {
        message = @"失败";
    }
    _logView.text = [NSString stringWithFormat:@"当前用户进入房间%d号%@",dwRoomId,message];
}

// 其他用户进入房间消息
- (void) OnChatUserEnterRoom:(int) dwUserId{
    _logView.text = [NSString stringWithFormat:@"有人进入房间 id =%d",dwUserId];
}

// 用户退出房间消息
- (void) OnChatUserLeaveRoom:(int) dwUserId{
    _logView.text = [NSString stringWithFormat:@"用户%d退出房间",dwUserId];
    _remoteIdText.text = @"";
}

// 网络断开消息
- (void) OnChatLinkClose:(int) dwErrorCode{
    _logView.text = [NSString stringWithFormat:@"网络断开errorCode=%d",dwErrorCode];
    _remoteIdText.text = @"";
}

//检测到自己与对方都已经进入成功，开始准备接入视频
- (void) OnChatPrepareVideo:(int)remoteId{
    _remoteIdText.text = [NSString stringWithFormat:@"%d",remoteId];
    HXVideoViewController *resultVC = [[HXVideoViewController alloc] init];
    resultVC.iRemoteUserId = remoteId;
    [self presentViewController:resultVC animated:NO completion:nil];
}

//连接anychat超时,即无回调
- (void) OnHXConnectTimeOut{
    //连接超时 请及时给出异常事件
    NSLog(@"TimeOut");
    _logView.text = @"TimeOut";
}

//用户主动挂断
-(void)OnUserHangUpEvent{
    _logView.text = @"用户主动挂断";
}
@end

//
//  HXVideoLib.m
//  HXVideoLib
//
//  Created by liuchunhua on 16/10/19.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import "HXVideoLib.h"

#define HXAnyChatTimeOut  15.0 //连接anyChat超时

@implementation OAQueueRspModel
-(id)init
{
    self = [super init];
    if (self) {
        _waitPosition = @"";
        _waitPositionInSelfOrg = @"";
        _waitNum = @"";
        _status = @"";
        _anyChatStreamIpOut = @"";
        _anyChatStreamPort = @"";
        _userName = @"";
        _loginPwd = @"";
        _roomId = @"";
        _roomPwd = @"";
        _remoteId = @"";
        _errorNo = @"";
        _errorInfo = @"";
    }
    
    return self;
}
@end

@interface HXVideoLib(){
    OAQueueRspModel *_rspModel;
    NSTimer *_delayTimer;
}

@property (nonatomic,strong) AnyChatPlatform  *anyChat;

@end

@implementation HXVideoLib
static HXVideoLib *_instance;

+(HXVideoLib *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

-(id)init{
    self = [super init];
    if (self){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AnyChatNotifyHandler:) name:@"ANYCHATNOTIFY" object:nil];
        [AnyChatPlatform InitSDK:0];
        _anyChat = [AnyChatPlatform getInstance];
        _anyChat.notifyMsgDelegate = self;
        _isEnter = false;
    }
    return self;
}

-(void)updateVideoParams{

    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_NETWORK_P2PPOLITIC : 1];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :320];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :240];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL :150000];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL :12];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_PRESETCTRL :2];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_QUALITYCTRL :2];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_GOPCTRL :15];
    // 采用本地视频参数设置，使参数设置生效
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :1];
}

-(void)onConnectAnyChat
{
    NSLog(@"onConnectAnyChat");
    [AnyChatPlatform Connect:_rspModel.anyChatStreamIpOut : [_rspModel.anyChatStreamPort intValue]];
}

#pragma mark - AnyChatNotifyMessageDelegate
// 连接服务器消息
- (void) OnAnyChatConnect:(BOOL) bSuccess
{
    NSLog(@"OnAnyChatConnect ---- %d",bSuccess);
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatConnect:)])){
        [_anyChatMessageDelegate OnChatConnect:bSuccess];
    }
    
    if (bSuccess) {
        [AnyChatPlatform Login:_rspModel.userName :_rspModel.loginPwd];
    }
    else {
        [self stop];
    }
}

// 用户登陆消息
- (void) OnAnyChatLogin:(int) dwUserId : (int) dwErrorCode
{
    NSLog(@"OnAnyChatLogin  ------%d",dwUserId);
    if (dwErrorCode == GV_ERR_SUCCESS) {
        [AnyChatPlatform EnterRoom:[_rspModel.roomId intValue] :_rspModel.roomPwd];
    }
    else {
        [self stop];
    }
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatLogin::)])){
        [_anyChatMessageDelegate OnChatLogin:dwUserId :dwErrorCode];
    }
}

// 本用户进入房间消息
- (void) OnAnyChatEnterRoom:(int) dwRoomId : (int) dwErrorCode
{
    NSLog(@"OnAnyChatEnterRoom ----- %d",dwErrorCode);
    if (dwErrorCode == GV_ERR_SUCCESS) {
        if (!_isEnter){
            [self getOnLineUser];
        }
    }
    else {
        [self stop];
    }
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatEnterRoom::)])){
        [_anyChatMessageDelegate OnChatEnterRoom:dwRoomId :dwErrorCode];
    }
}

// 其他用户进入房间消息
- (void) OnAnyChatUserEnterRoom:(int) dwUserId
{
    NSLog(@"OnAnyChatUserEnterRoom ----- %d",dwUserId);
    if (!_isEnter){
        [self getOnLineUser];
    }
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatUserEnterRoom:)])){
        [_anyChatMessageDelegate OnChatUserEnterRoom:dwUserId];
    }
}

// 房间在线用户消息
- (void) OnAnyChatOnlineUser:(int) dwUserNum : (int) dwRoomId
{
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatOnlineUser::)])){
        [_anyChatMessageDelegate OnChatOnlineUser:dwUserNum :dwRoomId];
    }
}

// 用户退出房间消息
- (void) OnAnyChatUserLeaveRoom:(int) dwUserId
{
    NSLog(@"OnAnyChatUserLeaveRoom ------%d",dwUserId);
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatUserLeaveRoom:)])){
        [_anyChatMessageDelegate OnChatUserLeaveRoom:dwUserId];
    }
}

// 网络断开消息
- (void) OnAnyChatLinkClose:(int) dwErrorCode {
    NSLog(@"OnAnyChatLinkClose ------ %d",dwErrorCode);
    if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatLinkClose:)])){
        [_anyChatMessageDelegate OnChatLinkClose:dwErrorCode];
    }
}

#pragma mark - Instance Method
- (void)AnyChatNotifyHandler:(NSNotification*)notify
{
    NSDictionary*dict = notify.userInfo;
    [_anyChat OnRecvAnyChatNotify:dict];
}

-(void)start:(NSDictionary *)dic{
    OAQueueRspModel *model = [[OAQueueRspModel alloc] init];
    model.anyChatStreamIpOut = [dic objectForKey:@"anyChatStreamIpOut"];
    model.anyChatStreamPort = [dic objectForKey:@"anyChatStreamPort"];
    model.userName = [dic objectForKey:@"userName"];
    model.loginPwd = [dic objectForKey:@"loginPwd"];
    model.roomId = [dic objectForKey:@"roomId"];
    model.roomPwd = [dic objectForKey:@"roomPwd"];
    model.remoteId = [dic objectForKey:@"remoteId"];
    NSLog(@"anyChaDic = %@",model);
    _rspModel = model;
    if ((![_rspModel.anyChatStreamIpOut isEqualToString:@""]) && (![_rspModel.anyChatStreamPort isEqualToString:@""])){
        _isEnter = false;
        
        //延迟0.1秒执行
        NSTimer *connectTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onConnectAnyChat) userInfo:nil repeats:NO];
        
        //执行15s 未返回成功进入视频页面的处理
        _delayTimer = [NSTimer scheduledTimerWithTimeInterval:HXAnyChatTimeOut target:self selector:@selector(delayAppNoResponse) userInfo:nil repeats:NO];
        
    }else{
        
    }
}

-(void)stop{
    _isEnter = YES;
    [NSThread sleepForTimeInterval:0.03];
    // 关闭摄像头
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    [AnyChatPlatform UserSpeakControl: [_rspModel.remoteId intValue] : NO];
    [AnyChatPlatform UserCameraControl: [_rspModel.remoteId intValue] : NO];
    [AnyChatPlatform LeaveRoom:-1];
    [AnyChatPlatform Logout];
    
}

-(void)delayAppNoResponse{
    NSLog(@"delayAppNoResponse = isEnter = %d",_isEnter);
    if (!_isEnter){
        if ((_anyChatMessageDelegate != nil) && [_anyChatMessageDelegate respondsToSelector:@selector(OnHXConnectTimeOut)]){
            [self stop];
            [_anyChatMessageDelegate OnHXConnectTimeOut];
        }
    }
}

-(void)getOnLineUser{
    NSMutableArray *onLineUserList = [[NSMutableArray alloc] initWithArray:[AnyChatPlatform GetOnlineUser]];
    NSLog(@"anyChat 返回的在线房间人 = %@ , 接口返回的remoteId = %@",onLineUserList,_rspModel.remoteId);
    for (int i =0;i<onLineUserList.count;i++){
        NSString *userID = [[onLineUserList objectAtIndex:i] stringValue];
//        if ([userID isEqualToString:_rspModel.remoteId])
        //todo 测试阶段 不校验
        {
            if ((_anyChatMessageDelegate !=nil) && ([_anyChatMessageDelegate respondsToSelector:@selector(OnChatPrepareVideo:)])){
                _isEnter = YES;
                [self stopDelayTimer];
                [self updateVideoParams];
                [NSThread sleepForTimeInterval:0.01];
                [_anyChatMessageDelegate OnChatPrepareVideo:[userID intValue]];
            }
            break;
        }
    }
}

-(void)stopDelayTimer{
    if (_delayTimer){
        [_delayTimer invalidate];
        _delayTimer = nil;
    }
}
@end

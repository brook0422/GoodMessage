//
//  HXVideoInterface.h
//  HXVideoLib
//
//  Created by liuchunhua on 16/10/16.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#define Version   @"1.0.0"

/**
 *	AnyChat 异步消息事件协议
 */
@protocol HXVideNotifyMessageDelegate <NSObject>
@optional
// 连接服务器消息
- (void) OnChatConnect:(BOOL) bSuccess;

// 当前用户登陆消息
- (void) OnChatLogin:(int) dwUserId : (int) dwErrorCode;

// 当前用户进入房间消息
- (void) OnChatEnterRoom:(int) dwRoomId : (int) dwErrorCode;

// 其他用户进入房间消息
- (void) OnChatUserEnterRoom:(int) dwUserId;

// 房间在线用户消息
- (void) OnChatOnlineUser:(int) dwUserNum : (int) dwRoomId;

// 用户退出房间消息
- (void) OnChatUserLeaveRoom:(int) dwUserId;

// 网络断开消息
- (void) OnChatLinkClose:(int) dwErrorCode;

//检测到自己与对方都已经进入成功，开始准备接入视频
- (void) OnChatPrepareVideo:(int)remoteId;

//连接anychat超时,即无回调
- (void) OnHXConnectTimeOut;

//用户主动挂断
- (void) OnUserHangUpEvent;
@end

/*****视频参数设置******/
#define NETWORK_P2PPOLITIC      @"1"  //是否优先使用P2P 1优先使用p2p
#define LOCALVIDEO_APPLYPARAM   @"1"  //屏蔽本地参数，采用服务器视频参数设置 0本地参数  1服务端参数
#define LOCALVIDEO_WIDTHCTRL    @"320"//本地视频分辨率
#define LOCALVIDEO_HEIGHTCTRL   @"240"//本地视频分辨率
#define LOCALVIDEO_BITRATECTRL  @"150000"//视频码率
#define LOCALVIDEO_FPSCTRL      @"12" //视频帧率
#define LOCALVIDEO_PRESETCTRL   @"2"  //性能均衡、效率优先
#define LOCALVIDEO_QUALITYCTRL  @"2"  //视频质量 普通、中等
#define LOCALVIDEO_GOPCTRL      @"15" //关键帧间隔


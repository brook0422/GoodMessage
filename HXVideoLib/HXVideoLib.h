//
//  HXVideoLib.h
//  HXVideoLib
//
//  Created by liuchunhua on 16/10/19.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"
#import "AnyChatObjectDefine.h"
#import "AnyChatPlatform.h"
#import "HXVideoInterface.h"

@interface OAQueueRspModel : NSObject
@property (nonatomic,copy) NSString * errorNo;
@property (nonatomic,copy) NSString * errorInfo;
@property (nonatomic,copy) NSString * waitPosition;
@property (nonatomic,copy) NSString * waitPositionInSelfOrg;
@property (nonatomic,copy) NSString * waitNum;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * anyChatStreamIpOut;
@property (nonatomic,copy) NSString * anyChatStreamPort;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * loginPwd;
@property (nonatomic,copy) NSString * roomId;
@property (nonatomic,copy) NSString * roomPwd;
@property (nonatomic,copy) NSString * remoteId;
@end

@interface HXVideoLib : NSObject<AnyChatNotifyMessageDelegate>

@property (nonatomic,weak)   id<HXVideNotifyMessageDelegate> anyChatMessageDelegate;
@property (nonatomic,assign) BOOL isEnter;//是否  连接、登录、进入 都成功，这些操作都已经完成,准备开始进入视频页面 (包含取消排队也作为同一个标记位)

+(HXVideoLib *)getInstance;

-(void) start:(NSDictionary *)dic;

-(void) stop;

@end

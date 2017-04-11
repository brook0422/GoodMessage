//
//  ViewController.h
//  HXVideoDemo
//
//  Created by liuchunhua on 16/10/16.
//  Copyright © 2016年 liuchunhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HXVideoLib/HXVideoLib.h>
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *ipText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *roomIdText;
@property (weak, nonatomic) IBOutlet UITextField *roomPwdText;
@property (weak, nonatomic) IBOutlet UITextField *userIdText;
@property (weak, nonatomic) IBOutlet UITextField *userPwdText;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (weak, nonatomic) IBOutlet UITextField *remoteIdText;
@property (weak, nonatomic) IBOutlet UIButton *connectVideo;
@end


//
//  UIViewController+HUD.h
//  MusicPlay
//
//  Created by lanou on 16/1/22.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface UIViewController (HUD)

//菊花出现
-(void)showHUBwith:(NSString *)str isHidden:(BOOL)isHidden;
//菊花隐藏
-(void)hidden;
//没网提示
-(void)nonetshowHUBwith:(NSString *)str isHidden:(BOOL)isHidden afterDelay:(NSInteger)delay;
//判断网路
-(BOOL)isnetWork;
@end

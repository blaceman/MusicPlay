//
//  UIViewController+HUD.m
//  MusicPlay
//
//  Created by lanou on 16/1/22.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "Reachability.h"
@implementation UIViewController (HUD)
//-(void)sayHello{
//    NSLog(@"sayHello");
//}


-(void)showHUBwith:(NSString *)str isHidden:(BOOL)isHidden{
        //显示网络数据
      MBProgressHUD*hud = [[MBProgressHUD alloc]initWithFrame:self.view.bounds];
       hud.mode = MBProgressHUDModeIndeterminate;
       hud.labelText = str;
    hud.tag = 1000;
        [hud show:YES];
        //        float progress = 0;
        //        while (progress < 1) {
        //            progress += 0.1;
        //            hud.progress = progress;
        //            usleep(50000);
        //        }
        [self.view addSubview:hud];
//    [self hidden];
}
-(void)hidden{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1000) {
            [(MBProgressHUD *)view hide:YES];
        }
    }
}
-(void)nonetshowHUBwith:(NSString *)str isHidden:(BOOL)isHidden afterDelay:(NSInteger)delay{
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hub.mode = MBProgressHUDModeText;
    hub.labelText = str;
    [hub show:YES];
    [self.view addSubview:hub];
    [hub hide:isHidden  afterDelay:delay];
}
-(BOOL)isnetWork{
    BOOL isnetwork;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没网");
            isnetwork = NO;
            
            break;
        case ReachableViaWiFi:
            isnetwork = YES;
            break;
        case ReachableViaWWAN:
            isnetwork = YES;
            break;
        default:
            break;
    }
    return isnetwork;
    
}
@end

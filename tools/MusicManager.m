//
//  MusicManager.m
//  MusicPlay
//
//  Created by lanou on 16/1/22.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicManager.h"
#import "MusicinfoModel.h"
#import "Reachability.h"
#import "UIViewController+HUD.h"
@interface MusicManager ()
@property (nonatomic,strong) NSMutableArray *modelDatAarry;
//@property (nonatomic,copy)datablock block;
@end
@implementation MusicManager
//单例对象的创建
+(instancetype)shareManager{
    
//    第一种方法GDP
    static MusicManager *manager = nil;
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[MusicManager alloc]init];
        }
    });
//    第二种
//    @synchronized(self) {
//        if (manager == nil) {
//            manager = [[MusicManager alloc]init];
//        }
//    }
    return manager;
}

//判断是否有网
//-(BOOL)isnetWork{
//    BOOL isnetwork;
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            NSLog(@"没网");
//            isnetwork = NO;
//            
//            break;
//        case ReachableViaWiFi:
//            isnetwork = YES;
//            break;
//        case ReachableViaWWAN:
//            isnetwork = YES;
//            break;
//        default:
//            break;
//    }
//    return isnetwork;
//}
-(NSInteger)returnModelDataArryCount{
    return self.modelDatAarry.count;
}

//block作为函数参数返回self.block
-(void)resquestDatablock:(datablock)myblock withVC:(UIViewController*)VC
{
    if ([VC isnetWork]) {
        
        NSArray *arr = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"]];
        [VC showHUBwith:@"正在加载网络" isHidden:NO];
        for (int i = 0; i < arr.count; i++) {
            MusicinfoModel *model = [MusicinfoModel modelWirhDic:arr[i]];
            [self.modelDatAarry addObject:model];
        }
        myblock(self.modelDatAarry);
        [VC hidden];
    }
    
    else{
        [VC nonetshowHUBwith:@"网络不好,请检查网络" isHidden:YES afterDelay:2];
    }
  
}

-(MusicinfoModel*)returnModelindex:(NSInteger)index{
    return (MusicinfoModel*)self.modelDatAarry[index];
}
-(NSMutableArray *)modelDatAarry
{
    if (_modelDatAarry == nil) {
        _modelDatAarry = [[NSMutableArray alloc]init];
    }
    return _modelDatAarry;
}
@end

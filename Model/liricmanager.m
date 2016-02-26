//
//  liricmanager.m
//  MusicPlay
//
//  Created by lanou on 16/1/27.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "liricmanager.h"
#import "lyricModel.h"

@interface liricmanager()
@property (nonatomic,assign)NSInteger currenlyric;

@end
@implementation liricmanager
#pragma mark --懒加载
-(NSMutableArray *)modelmarr{
    if (_modelmarr == nil) {
        _modelmarr = [[NSMutableArray alloc]init];
    }
    return _modelmarr;
}
#pragma mark --单例创建
+(instancetype)shareManager{
    static liricmanager *manager = nil;
    static dispatch_once_t onceTask;
    dispatch_once(&onceTask, ^{
        manager = [[liricmanager alloc]init];
    });
    return manager;
}
#pragma mark --处理歌词
-(void)setLyricDataArryWithLyricStr:(NSString *)lyricStr{
    
     [self.modelmarr removeAllObjects];
   
    if (lyricStr != nil) {
        NSArray *arr = [lyricStr componentsSeparatedByString:@"\n"];
        if (arr.count <= 1) {
            lyricModel *model = [[lyricModel alloc]init];
            model.lyricstr = @"没歌词";
            model.currentime = 01.00;
            [self.modelmarr addObject:model];
            self.currenlyric = -1;
        }
        for (int i = 0; i < arr.count - 1; i++) {
            NSString *time1 = arr[i];
            NSArray *lyricstr1 = [NSArray array];
            if ([time1 containsString:@"]"]) {
                lyricstr1 = [time1 componentsSeparatedByString:@"]"];
            }
            else{
                lyricstr1 = @[@"00:01.000",time1];
            }
            
            NSArray *timeArr = [lyricstr1[0] componentsSeparatedByString:@":"];
            NSString *timer = [timeArr[0] substringFromIndex:1];
            int min =  [timer intValue];
            float sec = [timeArr[1] floatValue];
            lyricModel *model = [[lyricModel alloc]init];
            model.lyricstr = lyricstr1[1];
            model.currentime = min * 60 + sec;
            [self.modelmarr addObject:model];
        }
        self.currenlyric = -1;
    }
    else {
        lyricModel *model = [[lyricModel alloc]init];
        model.lyricstr = @"没歌词";
        model.currentime = 01.00;
        [self.modelmarr addObject:model];
        self.currenlyric = -1;
    }
   
}

#pragma mark -- 返回数组的索引
-(NSUInteger)lyricRunprogress:(float)progress{
  
    for (lyricModel *model in [liricmanager shareManager].modelmarr) {
        if ((NSInteger)progress == (NSInteger)model.currentime) {
            self.currenlyric = [[liricmanager shareManager].modelmarr indexOfObject:model];
            return self.currenlyric;
        }
    }
  return self.currenlyric;
    
}

@end

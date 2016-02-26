//
//  MusicManager.h
//  MusicPlay
//
//  Created by lanou on 16/1/22.
//  Copyright © 2016年 luoweixian. All rights reserved.
//  网络请求

#import <Foundation/Foundation.h>
#import "MusicinfoModel.h"
#import <UIKit/UIKit.h>
typedef void(^datablock)(NSMutableArray *);
@interface MusicManager : NSObject
//@property (nonatomic,copy)datablock block;
//实例化一个单例对象
+(instancetype)shareManager;
//网络请求
-(void)resquestDatablock:(datablock)myblock withVC:(UIViewController*)VC;
//返回数组的个数
-(NSInteger)returnModelDataArryCount;
//返回MusicinfoModel类
-(MusicinfoModel*)returnModelindex:(NSInteger)index;
@end

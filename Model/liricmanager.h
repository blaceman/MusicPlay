//
//  liricmanager.h
//  MusicPlay
//
//  Created by lanou on 16/1/27.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface liricmanager : NSObject
@property (nonatomic,strong)NSMutableArray *modelmarr;
+(instancetype)shareManager;
//从大数据模型传进歌词来处理
-(void)setLyricDataArryWithLyricStr:(NSString*)lyricStr;
-(NSUInteger)lyricRunprogress:(float)progress;
@end

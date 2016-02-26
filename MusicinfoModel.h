//
//  MusicinfoModel.h
//  MusicPlay
//
//  Created by lanou on 16/1/21.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <Foundation/Foundation.h>
//model存放数据 处理数据
@interface MusicinfoModel : NSObject
@property (nonatomic,copy) NSString*mp3Url;     //音频url
@property (nonatomic,copy) NSString*identify;  //id验证什么的
@property (nonatomic,copy) NSString*name;        //歌曲名称
@property (nonatomic,copy) NSString*picUrl;      //图像
@property (nonatomic,copy) NSString*blurPicUrl;   //模糊
@property (nonatomic,copy) NSString*album;       //专辑
@property (nonatomic,copy) NSString*singer;      //歌手
@property (nonatomic,copy) NSString*duration;    //时间
@property (nonatomic,copy) NSString*artists_name; //作曲人
@property (nonatomic,copy) NSString*lyric;       //歌词

//@property (nonatomic,assign) NSInteger ids;
+(instancetype)modelWirhDic:(NSDictionary*)dic;

@end

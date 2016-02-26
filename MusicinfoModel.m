//
//  MusicinfoModel.m
//  MusicPlay
//
//  Created by lanou on 16/1/21.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicinfoModel.h"

@implementation MusicinfoModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

//根据词典初始化数据
+(instancetype)modelWirhDic:(NSDictionary *)dic{
    MusicinfoModel *model = [MusicinfoModel new];
    model.mp3Url = dic[@"mp3Url"];
    model.identify = dic[@"id"];
    model.name = dic[@"name"];
    model.picUrl = dic[@"picUrl"];
    model.blurPicUrl = dic[@"blurPicUrl"];
    model.album = dic[@"album"];
    model.singer = dic[@"singer"];
    model.duration = dic[@"duration"];
    model.artists_name = dic[@"artists_name"];
    model.lyric = dic[@"lyric"];
    return model;
    
}

@end

//
//  MusicAudiomanager.h
//  MusicPlay
//
//  Created by lanou on 16/1/26.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <Foundation/Foundation.h>
//typedef NS_ENUM(NSInteger,MusicRunModel){
//    MusicRunModelListLoop  = 0,
//    MusicRunModelrundomLoop  = 1,
//    MusicRunModelSingleLoop  = 2,
//    MusicRunModelCurrenLoop  = 3
//};

//MusicAudiomanagerDelegate
@protocol MusicAudiomanagerDelegate <NSObject>

-(void)audioPlayWithProgress:(float)progress;
-(void)timerAction;
//代理方法
-(void)audioPlayEndtime;

@end
@interface MusicAudiomanager : NSObject
@property (nonatomic,assign)BOOL isPlaying;
@property (nonatomic,assign)float volumn;
@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,weak)id<MusicAudiomanagerDelegate>delegate;
+(instancetype)shareManager;

-(void)setMusicAudioMusicUrl:(NSString*)musicurl;
-(void)play;
-(void)pause;
-(BOOL)isPlayingCurrenAudioWithUrl:(NSString *)url;
-(void)seekToTimePlay:(float)time;
-(float)currentime;
@end

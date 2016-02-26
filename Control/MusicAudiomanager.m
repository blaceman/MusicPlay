//
//  MusicAudiomanager.m
//  MusicPlay
//
//  Created by lanou on 16/1/26.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicAudiomanager.h"
#import <AVFoundation/AVFoundation.h>
#import "liricmanager.h"
#import "lyricModel.h"
@interface MusicAudiomanager ()
@property (nonatomic,strong) AVPlayer *avplay;
@property (nonatomic,strong) NSTimer *timer;

@end
@implementation MusicAudiomanager

#pragma mark --懒加载
-(NSArray *)arr{
    if (_arr == nil) {
        _arr = [[NSMutableArray alloc]initWithObjects:@(1),@(0),@(0),@(0), nil];
    }
    return _arr;
}
-(AVPlayer *)avplay{
    if (!_avplay) {
        _avplay = [[AVPlayer alloc]init];
    }
    return _avplay;
}
//--------------------------------------------------------------------
#pragma mark --系统初始化
-(instancetype)init{
    if (self = [super init]) {
//        注册 self.avplay播放结束的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(audioEndHandle) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

#pragma mark --单例对象的创建
+(instancetype)shareManager{
    static MusicAudiomanager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[MusicAudiomanager alloc]init];
        }
    });
    return manager;
}

#pragma mark --方法
//注册 self.avplay播放结束的通知Action
-(void)audioEndHandle{
    [self.timer invalidate];
    self.timer = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayEndtime)]) {
        [self.delegate audioPlayEndtime];
    }
    
}
//set音量
-(void)setVolumn:(float)volumn{
    self.avplay.volume = volumn;
}
//音量getter
-(float)volumn{
    return self.avplay.volume;
}
//处理音乐
-(void)setMusicAudioMusicUrl:(NSString *)musicurl{
    if (self.avplay.currentItem) {
        [self.avplay.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:musicurl]];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.avplay replaceCurrentItemWithPlayerItem:item];
}

//观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSInteger new = [change[@"new"] integerValue];
    switch (new) {
        case AVPlayerItemStatusFailed:
            NSLog(@"AVPlayerItemStatusFailed");
            break;
            case AVPlayerItemStatusUnknown:
            NSLog(@"AVPlayerItemStatusUnknown");
            break;
            case AVPlayerItemStatusReadyToPlay:
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            [self play];
            if (self.delegate && [self.delegate respondsToSelector:@selector(timerAction)]) {
                [self.delegate timerAction];
            }
//        [object removeObserver:self forKeyPath:@"status"];
            break;
        default:
            break;
    }
}
//播放
-(void)play{
   
    [self.avplay play];
    self.isPlaying = YES;
    if ([_timer isValid]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimerHandle) userInfo:nil repeats:YES];
}
//暂停
-(void)pause{
    [self.avplay pause];
    self.isPlaying = NO;
    [_timer invalidate];
    _timer = nil;
}
//定时器处理
-(void)TimerHandle{
    //代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayWithProgress:)]) {
        //获取当前时间
        float seconds = self.avplay.currentTime.value / self.avplay.currentTime.timescale;
        ///响应代理方法处理时间
        [self.delegate audioPlayWithProgress:seconds];
    }
    
    
}
//判断当前播放的是否和重新进来的一样
-(BOOL)isPlayingCurrenAudioWithUrl:(NSString *)url{
    NSString *currenURL =[[((AVURLAsset *)self.avplay.currentItem.asset) URL] absoluteString];
    if ([currenURL isEqualToString:url]) {
        return YES;
    }
    else{
        return NO;
    }
    
}
//调到指定的时间播放
-(void)seekToTimePlay:(float)time{
    [self.avplay pause];
    [self.avplay seekToTime:CMTimeMakeWithSeconds(time, self.avplay.currentTime.timescale)];
    [self.avplay play];
}
////当前时间
//-(float)currentime{
//  return [self.avplay currentTime].value / [self.avplay currentTime].timescale;
//}
@end

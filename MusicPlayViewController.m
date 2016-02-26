//

//  MusicPlayViewController.m
//  MusicPlay
//
//  Created by lanou on 16/1/25.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicPlayViewController.h"
#import "MusicinfoModel.h"
#import "MusicManager.h"
#import "UIImageView+WebCache.h"
#import "MusicAudiomanager.h"
#import "liricmanager.h"
#import "lyricModel.h"
@interface MusicPlayViewController ()<UITableViewDataSource,UITableViewDelegate,MusicAudiomanagerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainwideh;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPageControl *processmusic;
@property (weak, nonatomic) IBOutlet UIImageView *backimageView;
@property (weak, nonatomic) IBOutlet UILabel *musiccurrenLabel;//
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *musictotleLabel;
@property (weak, nonatomic) IBOutlet UISlider *volumeslide;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lspecialAlbumLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressslider;
@property (weak, nonatomic) IBOutlet UIButton *loopBtn;
@property (weak, nonatomic) IBOutlet UIButton *shuffle;
@property (weak, nonatomic) IBOutlet UIButton *singleloopBtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *pauseBTn;
@property (nonatomic,strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;



@end

@implementation MusicPlayViewController


#pragma mark --Action
//pageAction
- (IBAction)PageAction:(UIPageControl *)sender {
    self.scrollView.contentOffset = CGPointMake(self.processmusic.currentPage * self.view.bounds.size.width, 0);
}

//滑动音乐播放器进度
- (IBAction)MusicSilder:(UISlider *)sender {
     [[MusicAudiomanager shareManager]seekToTimePlay:sender.value];
}

//声音大小
- (IBAction)volumeSlirValueChange:(UISlider *)sender {
    [[MusicAudiomanager shareManager]setVolumn:sender.value];
}
//循坏播放
- (IBAction)loopBtnAction:(id)sender {
    NSArray *arr = @[@(1),@(0),@(0),@(0)];
    [MusicAudiomanager shareManager].arr = arr;
    self.loopBtn.selected = YES;
     self.shuffle.selected = NO;
    self.singleloopBtn.selected = NO;
    self.musicBtn.selected = NO;
    
}
//随机播放
- (IBAction)shuffleBtnAction:(id)sender {
    NSArray *arr = @[@(0),@(1),@(0),@(0)];
    [MusicAudiomanager shareManager].arr = arr;
    self.loopBtn.selected = NO;
    self.shuffle.selected = YES;
    self.singleloopBtn.selected = NO;
    self.musicBtn.selected = NO;
   
}
//单曲循坏
- (IBAction)singleBtnAction:(id)sender {
    NSArray *arr = @[@(0),@(0),@(1),@(0)];
    [MusicAudiomanager shareManager].arr = arr;
    self.loopBtn.selected = NO;
    self.shuffle.selected = NO;
    self.singleloopBtn.selected = YES;
    self.musicBtn.selected = NO;
   
}
- (IBAction)musicBtnAction:(id)sender {
    NSArray *arr = @[@(0),@(0),@(0),@(1)];
   [MusicAudiomanager shareManager].arr = arr;
    self.loopBtn.selected = NO;
    self.shuffle.selected = NO;
    self.singleloopBtn.selected = NO;
    self.musicBtn.selected = YES;

}

//右上角返回
- (IBAction)retrunButtion:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
//上一首
- (IBAction)rewindBtn:(id)sender {
    [self ModeNextOrRewind:@"rewind"];
  
}
//下一首
- (IBAction)forwardBtn:(id)sender {
    
    [self ModeNextOrRewind:@"next"];
    
}
//播放 暂停
- (IBAction)pauseBtn:(id)sender {
    if ([MusicAudiomanager shareManager].isPlaying) {
        [[MusicAudiomanager shareManager]pause];
        [_timer invalidate];
        _timer = nil;
        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
         [sender setImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
    }
    else{
        [[MusicAudiomanager shareManager]play];
        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
        if ([_timer isValid]) {
            return;
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rotateAction) userInfo:nil repeats:YES];
    }
    
}
//旋转Action
-(void)rotateAction{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI / 300);
    
}
//------------------------------------------------------------------//

#pragma mark --播放模式
-(void)ModeNextOrRewind:(NSString *)nextOrRewind{
    MusicAudiomanager *manager = [MusicAudiomanager shareManager];
    if ([manager.arr[0]  isEqual: @(1)]) {
        //上一首
        if ([nextOrRewind isEqualToString:@"rewind"]) {
            self.currentIndex--;
            if (self.currentIndex < 0) {
                self.currentIndex = [[MusicManager shareManager] returnModelDataArryCount] - 1;
            }
        }
        //下一首
        else{
            self.currentIndex ++;
            if (self.currentIndex > [[MusicManager shareManager] returnModelDataArryCount] - 1) {
                self.currentIndex = 0;
            }
        }
        
        [self reloadViewData];
    }
    //随机播放
    else if ([manager.arr[1] isEqual:@(1)]){
        self.currentIndex = arc4random() % ([[MusicManager shareManager] returnModelDataArryCount] + 1);
        [self reloadViewData];
    }
    //单曲循环
    else if ([manager.arr[2] isEqual:@(1)]){
        [self reloadViewData];
    }
}

//------------------------------------------------------------------//
#pragma mark --加载数据、数据处理
//数据加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.volumeslide.value = 1;
    
    //thumb自定义
    [self.progressslider setThumbImage:[UIImage imageNamed:@"thumb@2x.png"] forState:UIControlStateNormal];
    [self.volumeslide setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x"] forState:UIControlStateNormal];
    
    //签订协议
    [MusicAudiomanager shareManager].delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.scrollView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //cell注册
    [self.tableView dequeueReusableCellWithIdentifier:@"reuse"];
    
    //musicNameLabel.text先赋初值
    self.musicNameLabel.text = @"我是逗比";
    
    //添加观察者
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"你好厉害"];
    [self.musicNameLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    //处理数据
    [self reloadViewData];
    //通知传值
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectindexNotifiHandle:) name:@"selectedindex" object:nil];

}
//-(void)selectindexNotifiHandle:
//数据处理 单例方法
-(void)reloadViewData{
    
//    self.scrollView 按页滚动 隐藏bar
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
//    加载数据时定时器停止
    [self.timer invalidate];
    self.timer = nil;
    
        MusicinfoModel *info = [[MusicManager shareManager] returnModelindex:self.currentIndex];
    
    //网络请求加载图片
    [self.backimageView sd_setImageWithURL:[NSURL URLWithString:info.blurPicUrl]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:info.picUrl]];
    
//处理数据
    //处理歌词
    [[liricmanager shareManager]setLyricDataArryWithLyricStr:info.lyric];
    
    
    [self.tableView reloadData];
    //Slider的最大值
    self.progressslider.maximumValue = [info.duration floatValue] / 1000;
    self.progressslider.value = 0;
    
    //歌名
    self.musicNameLabel.text = info.name;
    
    //专辑名
    self.lspecialAlbumLabel.text = [NSString stringWithFormat:@"%@-%@",info.singer,info.album];
    
    //处理当前总时长
    self.musictotleLabel.text = [self strWithTime:info.duration];
    
//   加载音频音乐
    //判断每次传进来MP3url是否一样
    //    if (![[MusicAudiomanager shareManager] isPlayingCurrenAudioWithUrl:info.mp3Url]) {
    //使用单例类 加载音乐播放器
    [[MusicAudiomanager shareManager] setMusicAudioMusicUrl:info.mp3Url];
    //    }
    
    
//    播放模式的状态
    MusicAudiomanager *audioManager = [MusicAudiomanager shareManager];
    self.loopBtn.selected = [audioManager.arr[0] integerValue];
    self.shuffle.selected = [audioManager.arr[1] integerValue];
    self.singleloopBtn.selected = [audioManager.arr[2] integerValue];
    self.musicBtn.selected = [audioManager.arr[3] integerValue];


}
//将字段的时间转为分秒
-(NSString*)strWithTime:(NSString*)time{
    NSInteger time1 = [time integerValue];
    NSInteger minute = time1 / 1000 / 60;
    NSInteger second = time1 / 1000 % 60;
    return [NSString stringWithFormat:@"-%ld:%02ld",minute,second];
    //  NSString *time1 = [NSString stringWithFormat:@".f",time];
    
}
//------------------------------------------------------------------
#pragma mark --观察者
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"%@",context);
    if (self.block) {
        self.block(self.imageView.image,self.currentIndex,self.musicNameLabel.text);
    }
    
}
-(void)dealloc{
    [self.imageView removeObserver:self forKeyPath:@"image"];
    [self.musicNameLabel removeObserver:self forKeyPath:@"text"];
}
//------------------------------------------------------------------

#pragma mark --约束更新
-(void)updateViewConstraints{
    [super updateViewConstraints];
    self.constrainwideh.constant = self.view.bounds.size.width * 2;
    self.tableViewWith.constant = self.view.bounds.size.width;
    self.viewWidth.constant = (self.view.bounds.size.width - 150) / 2;
}
//------------------------------------------------------------------


#pragma mark --tableview 协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [liricmanager shareManager].modelmarr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    
    lyricModel *model =[liricmanager shareManager].modelmarr[indexPath.row];
    
    //歌词
    cell.textLabel.text = model.lyricstr;
    //字体居中
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.textColor = [UIColor whiteColor];
//    cell背景颜色为空
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    //设计系统textLabel 字体自适应
    [cell.textLabel setNumberOfLines:0];
    
//    自定义seleced的cell
    UIView *view =  [[UIView alloc]initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    return cell;
}
//--------------------------------------------------------------------

#pragma mark --MusicAudioManagerDelegate
//音乐播放进程
-(void)audioPlayWithProgress:(float)progress{
    self.progressslider.value = progress;
    NSInteger min = (NSInteger)progress / 60;
    NSInteger sec = (NSInteger)progress % 60;
    self.musiccurrenLabel.text = [NSString stringWithFormat:@"-%ld:%02ld",min,sec] ;
  
//    歌词滚动
//    self.tableView scrollToRowAtIndexPath:<#(nonnull NSIndexPath *)#> atScrollPosition:<#(UITableViewScrollPosition)#> animated:<#(BOOL)#>
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];;
    
//  判断是否歌词开始,没有开始时返回为-1
    if ([[liricmanager shareManager] lyricRunprogress:progress] != -1) {
//        当前歌词所在tableView 的row
        NSUInteger currenlyric = [[liricmanager shareManager] lyricRunprogress:progress];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currenlyric   inSection:0];
//        选择到当前歌词所在tableView 的row
        [self.tableView selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
 
}

//音乐开始timerAction开始执行 转盘开始转动
-(void)timerAction{
    if ([_timer isValid]) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(rotateAction) userInfo:nil repeats:YES];    
}
//下一首
-(void)audioPlayEndtime{
    [self ModeNextOrRewind:@"next"];
    
}
//--------------------------------------------------------------------
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x >= self.view.bounds.size.width / 2 ) {
        self.processmusic.currentPage = 1;
    }
    else{
        self.processmusic.currentPage = 0;
    }
    
}

@end

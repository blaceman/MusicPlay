//
//  MusicListViewController.m
//  MusicPlay
//
//  Created by lanou on 16/1/21.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicListViewController.h"
#import "Reachability.h"
#import "MusicListCell.h"
#import "MBProgressHUD.h"
#import "MusicinfoModel.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HUD.h"
#import "MusicManager.h"
#import "MusicPlayViewController.h"
@interface MusicListViewController ()<UITableViewDelegate,UITableViewDataSource,MusicListCellDelegate>
@property (nonatomic,strong)UITableView* tableview;
@property (nonatomic,strong)NSMutableArray *modelArry;
@property (nonatomic,strong)NSMutableDictionary *mdic;
@property (nonatomic,strong)UIImageView *imageView;
//记录当前播放歌曲的row
@property (nonatomic,assign)NSInteger currenIndexRow;
//将推出的视图控制器设置为属性,防止dismiss时视图控制器被释放
@property (nonatomic,strong)MusicPlayViewController *musicP;
@end

@implementation MusicListViewController

#pragma mark --懒加载
-(NSMutableDictionary *)mdic
{
    if (_mdic == nil) {
        self.mdic = [NSMutableDictionary new];
    }
    return _mdic;
}
-(NSMutableArray*)modelArry{
    if (_modelArry == nil) {
        self.modelArry = [[NSMutableArray alloc]init];
    }
    return _modelArry;
}
//--------------------------------------------------------------------
#pragma mark -- TapHandle
-(void)RightbtnTapHandle{
    if (self.musicP != nil) {
        [self.navigationController presentViewController:self.musicP animated:YES completion:NULL];
    }
    
}
//--------------------------------------------------------------------
#pragma mark --加载数据、处理数据
//设置self.tableView 背景为毛玻璃效果
-(void)loadbackimageView{
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    if (self.imageView.image == nil) {
        self.imageView.image = [UIImage imageNamed:@"1"];
    }
    
//    毛玻璃效果
    //  visual 可视的 视觉的
        UIVisualEffectView *visual = [[UIVisualEffectView alloc]initWithFrame:self.view.bounds];
        //    blur 模糊的  模糊效果
        visual.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        [self.imageView addSubview:visual];
       self.tableview.backgroundView = self.imageView;

}
//加载视图
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.currenIndexRow 赋初值
    self.currenIndexRow = -100;
    
//    self.title赋初值
    self.title = @"音乐列表";
    
    //    self.navigationController.navigationBar.translucent = NO;
    //下面的这句话 当有导航时候 00点 顶着导航 2.没有导航的时候顶着屏幕00点以及最高点
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

   //右上角的Button
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setImage:[UIImage imageNamed:@"music-s"] forState:UIControlStateNormal];
    [customBtn setImage:[UIImage imageNamed:@"music"] forState:UIControlStateHighlighted];
    customBtn.frame = CGRectMake(0, 0, 30, 30);
    //设计Button的Action
    [customBtn addTarget:self action:@selector(RightbtnTapHandle) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    
     self.tableview = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
//    self.tableview.backgroundView 设计为毛玻璃效果
    [self loadbackimageView];
//  指定代理人
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //把多余的分割线隐藏
    self.tableview.tableFooterView = [UIView new];
    
//    注册cell
    [self.tableview registerClass:[MusicListCell class] forCellReuseIdentifier:@"MusicListCell"];
    
    [self.view addSubview:self.tableview];
    
    
//MusicMannager加载数据
    MusicManager *musicManager = [MusicManager shareManager];
    [musicManager resquestDatablock:^(NSMutableArray *marr) {
             self.modelArry = marr;
//            [self.tableview reloadData];
    } withVC:self];
    
}
//创建self.musicP
-(void)CurrenindexRowIsNotindexRow{
    //   不相等就让self.musicP 置空
    self.musicP = nil;
    self.musicP = [[MusicPlayViewController alloc]init];
    
    //    网络请求所需的数组所需的索引 即播放那首歌所需要的数据的索引
    self.musicP.currentIndex = self.currenIndexRow;
    
    //    self 持有了 self.musicP self.musicP 持有了block block持有了self 三者相互持有谁有释放不了谁 所以要加 typeof(self) __weak weakSelf = self; 让 self 为weak
    typeof(self) __weak weakSelf = self;
    self.musicP.block = ^(UIImage *image,NSInteger currenrow,NSString *title){
        weakSelf.imageView.image = image;
        weakSelf.tableview.backgroundView = weakSelf.imageView;
        weakSelf.currenIndexRow = currenrow;
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:currenrow inSection:0];
        [weakSelf.tableview selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        weakSelf.title = title;
    };
    [self.navigationController presentViewController:self.musicP animated:YES completion:NULL];
}
//--------------------------------------------------------------------
#pragma mark --UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    MusicManager 单例返回数组个数
    MusicManager *musicmanager = [MusicManager shareManager];
    return [musicmanager returnModelDataArryCount];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell注册
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicListCell" forIndexPath:indexPath];
    
//    MusicManager 单例获取cellwithModel
     MusicManager *musicmanager = [MusicManager shareManager];
    [cell cellwithmodel:[musicmanager returnModelindex:indexPath.row]];
    
    //cell的背景颜色为透明
    cell.backgroundColor = [UIColor clearColor];
    
//    cell 指定代理人
    cell.delegate = self;
    
//    设计cell选中的颜色为透明
    cell.selectedBackgroundView= [[UIView alloc]initWithFrame:cell.frame ];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    return cell;
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
// 判断当前 indexRow 是否等于 self.currenIndexRow  不相等就等于换歌 相等即是当前的歌
    if (self.currenIndexRow != indexPath.row) {
//        记录当前是第几行 即记录是哪首歌
        self.currenIndexRow = indexPath.row;
        
//      创建新的视图控制器 即播放那首歌
        [self CurrenindexRowIsNotindexRow];
    }
    else{

        [self.navigationController presentViewController:self.musicP animated:YES completion:NULL];
    }
   
}
//--------------------------------------------------------------------


#pragma mark -- MusicListCellDelegate
-(void)passimageView:(UIImage *)image{
//    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = image;
    self.tableview.backgroundView = self.imageView;

}


@end

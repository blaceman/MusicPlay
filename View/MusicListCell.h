//
//  MusicListCell.h
//  MusicPlay
//
//  Created by lanou on 16/1/21.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicinfoModel.h"

//MusicListCellDelegate协议方法
@protocol MusicListCellDelegate <NSObject>

-(void)passimageView:(UIImage*)image;

@end
@interface MusicListCell : UITableViewCell
@property (nonatomic,strong) UIImageView *picImageView; //图片
@property (nonatomic,strong) UILabel *musicNameLabel;  //音乐名字
@property (nonatomic,strong) UILabel *singerNameLael; //歌手名字
@property (nonatomic,weak) id<MusicListCellDelegate>delegate;
-(void)cellwithmodel:(MusicinfoModel*)model;
@end

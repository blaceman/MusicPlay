//
//  MusicListCell.m
//  MusicPlay
//
//  Created by lanou on 16/1/21.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import "MusicListCell.h"
#import "UIImageView+WebCache.h"

@interface MusicListCell ()
@end
@implementation MusicListCell

#pragma mark --懒加载
//picImageView懒加载
-(UIImageView *)picImageView
{
    if (_picImageView == nil) {
        self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 55, 55)];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}
//musicNameLabel懒加载
-(UILabel *)musicNameLabel{
    if (!_musicNameLabel) {
        _musicNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.picImageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - 82, 21)];
        [self.contentView addSubview:_musicNameLabel];
    }
    return _musicNameLabel;
}
//singerNameLael懒加载
-(UILabel *)singerNameLael{
    if (!_singerNameLael) {
        _singerNameLael = [[UILabel alloc]initWithFrame:CGRectMake(85, 10, [UIScreen mainScreen].bounds.size.width - 82, CGRectGetMaxY(self.picImageView.frame) + 20)];
//        _singerNameLael.textColor = [UIColor redColor];
        [self.contentView addSubview:_singerNameLael];
    }
    return _singerNameLael;
}

#pragma mark --方法
//-cellwithmodel: set方法
-(void)cellwithmodel:(MusicinfoModel *)model{
  
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    
    self.musicNameLabel.text = model.name;
    self.singerNameLael.text = model.singer;
    self.singerNameLael.highlightedTextColor = [UIColor redColor];
    
}

#pragma mark --系统选中的方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected == YES) {
        self.musicNameLabel.textColor = [UIColor yellowColor];
//        协议方法的执行
        if (self.delegate != nil &&[self.delegate respondsToSelector:@selector(passimageView:)]) {
            [self.delegate passimageView:self.picImageView.image];
            
        }
        
    }
    else{
        self.musicNameLabel.textColor = [UIColor blackColor];
        }
   
}


@end

//
//  MusicPlayViewController.h
//  MusicPlay
//
//  Created by lanou on 16/1/25.
//  Copyright © 2016年 luoweixian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayViewController : UIViewController
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong) void(^block)(UIImage *image,NSInteger currenrow,NSString *title);
@end

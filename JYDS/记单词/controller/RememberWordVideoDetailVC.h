//
//  RememberWordVideoDetailVC.h
//  JYDS
//
//  Created by dayu on 2016/11/30.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseVideo;
@protocol RememberWordVideoDetailVCDelegate<NSObject>
- (void)reloadVideoList;
@end
@interface RememberWordVideoDetailVC : UIViewController

@property (strong,nonatomic) CourseVideo *video;
@property (nonatomic,strong) NSArray *videoArray;
@property (weak,nonatomic) id<RememberWordVideoDetailVCDelegate> delegate;

@end

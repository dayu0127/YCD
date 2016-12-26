//
//  MemoryCourseVC.h
//  YCD
//
//  Created by dayu on 2016/11/29.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Mnemonics;
@interface MemoryCourseVC : BaseViewController
/** 课程视频ID */
@property (nonatomic, copy) NSString *courseID;
/** 课程视频名 */
@property (nonatomic, copy) NSString *courseName;
/** 课程视频URL */
@property (nonatomic, strong) NSURL *courseVideo;
/** 课程视频说明 */
@property (nonatomic, copy) NSString *courseInstructions;
/** 其他课程 */
@property (nonatomic,strong) NSArray<Mnemonics *> *memoryArray;
@end

//
//  YHDataSource.h
//  YCD
//
//  Created by liyu on 2016/12/24.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHCellConfigure.h"
typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
IB_DESIGNABLE
@interface YHDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource>
//--------- For Code
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before;

//--------- For StoryBoard

@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@property (nonatomic, copy) CellConfigureBefore cellConfigureBefore;

//---------Public

- (void)addModels:(NSArray *)models;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;
@end

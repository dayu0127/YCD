//
//  WordSubedList.m
//  JYDS
//
//  Created by liyu on 2017/4/10.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "WordSubedList.h"
#import "SubedCell.h"
#import "Word.h"
#import "WordDetailVC.h"

@interface WordSubedList ()<UITableViewDelegate,UITableViewDataSource,WordDetailVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *subedWordList;
@property (strong,nonatomic) Word *word;
@property (strong,nonatomic) NSMutableArray *collectStateArr;
@property (assign,nonatomic) NSInteger currentRow;
@end

@implementation WordSubedList


- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerClass:[SubedCell class] forCellReuseIdentifier:@"SubedCell"];
    //    {
    //        "userPhone":"******"    #用户手机号
    //        "token":"****"          #登陆凭证
    //        "unitId"："****"         #单元id
    //        "classId"："****"        #课本id
    //        "pageIndex":1           #当前页数
    //    }
    [YHHud showWithStatus];
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                              @"unitId" :_unitId,    // #单元ID
                              @"pageIndex":@"1",         //  #当前页数
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        [YHHud dismiss];
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _subedWordList = [NSMutableArray arrayWithArray:resultDic[@"subWordList"]];
            [_tableView reloadData];
            _collectStateArr = [NSMutableArray arrayWithCapacity:_subedWordList.count];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        [YHHud dismiss];
        NSLog(@"%@",error);
    }];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subedWordList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    SubedCell *cell = (SubedCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[SubedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    static NSString *CellIdentifier = @"Cell";
//    SubedCell *cell = [tableView cellForRowAtIndexPath:indexPath]; //根据indexPath准确地取出一行，而不是从cell重用队列中取出
//    if (cell == nil) {
//        cell = [[SubedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.collectButton.tag = indexPath.row;
//        [_collectStateArr addObject:_subedWordList[indexPath.row][@"collectionType"]];
//    }
    
    SubedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubedCell" forIndexPath:indexPath];
//    cell.collectButton.tag = indexPath.row;
//    _currentRow = indexPath.row;
//    cell.collectButton.tag = indexPath.row;
//    [cell.collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addModelWithDic:_subedWordList[indexPath.row]];
    return cell;
}
- (void)collectButtonClick:(UIButton *)sender{
//    NSInteger index = [_collectStateArr[sender.tag] integerValue];;
    NSLog(@"%zd",sender.tag);
    NSLog(@"%zd",_currentRow);
//    if (_currentRow == sender.tag) {
        if ([_subedWordList[sender.tag][@"collectionType"] integerValue] == 0) {//单词收藏
            //        {
            //            "userPhone":"******"    #用户手机号
            //            "token":"****"          #登陆凭证
            //            "unitId"："****"         #单元id
            //            "classId"："****"        #课本id
            //            "wordId":"**"           #单词id
            //        }
            NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                                      @"unitId" :_unitId,    // #单元ID
                                      @"wordId":_subedWordList[sender.tag][@"wordId"],         //  #当前页数
                                      @"userPhone":self.phoneNum,     //  #用户手机号
                                      @"token":self.token};       //   #登陆凭证
            [YHWebRequest YHWebRequestForPOST:kCollectionWord parameters:jsonDic success:^(NSDictionary *json) {
                if([json[@"code"] integerValue] == 200){
                    //刷新单词收藏图片
                    for (NSInteger i = 0; i<_subedWordList.count; i++) {
                        NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_subedWordList objectAtIndex:i]];
                        if ([item[@"wordId"] integerValue] == [_subedWordList[sender.tag][@"wordId"] integerValue]) {
                            [item setObject:[NSNumber numberWithInt:1] forKey:@"collectionType"];
                        }
                        [_subedWordList replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
                    }
                    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                    [YHHud showWithMessage:@"收藏成功"];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    NSLog(@"%@",json[@"message"]);
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }else{//单词取消收藏
            //        {
            //            "userPhone":"******"    #用户手机号
            //            "token":"****"          #登陆凭证
            //            "unitId"："****"         #单元id
            //            "classId"："****"        #课本id
            //            "wordId":"**"           #单词id
            //        }
            
            NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                                      @"unitId" :_unitId,    // #单元ID
                                      @"wordId":_subedWordList[sender.tag][@"wordId"],         //  #当前页数
                                      @"userPhone":self.phoneNum,     //  #用户手机号
                                      @"token":self.token};       //   #登陆凭证
            [YHWebRequest YHWebRequestForPOST:kCancelCollectionWord parameters:jsonDic success:^(NSDictionary *json) {
                if([json[@"code"] integerValue] == 200){
                    //刷新单词收藏图片
                    for (NSInteger i = 0; i<_subedWordList.count; i++) {
                        NSMutableDictionary *item = [[NSMutableDictionary alloc] initWithDictionary:[_subedWordList objectAtIndex:i]];
                        if ([item[@"wordId"] integerValue] == [_subedWordList[sender.tag][@"wordId"] integerValue]) {
                            [item setObject:[NSNumber numberWithInt:0] forKey:@"collectionType"];
                        }
                        [_subedWordList replaceObjectAtIndex:i withObject:[NSDictionary dictionaryWithDictionary:item]];
                    }
                    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
//                    [_tableView reloadData];
                    [YHHud showWithMessage:@"已取消收藏"];
                }else{
                    NSLog(@"%@",json[@"code"]);
                    NSLog(@"%@",json[@"message"]);
                }
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _word = [Word yy_modelWithJSON:_subedWordList[indexPath.row]];
    [self performSegueWithIdentifier:@"toWordSubedDetail" sender:self];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    WordDetailVC *wordDetailVC = segue.destinationViewController;
    wordDetailVC.delegate = self;
    wordDetailVC.word = _word;
    wordDetailVC.classId = _classId;
    wordDetailVC.unitId = _unitId;
}
- (void)updateWordList{
    NSDictionary *jsonDic = @{@"classId":_classId,    //  #版本ID
                              @"unitId" :_unitId,    // #单元ID
                              @"pageIndex":@"1",         //  #当前页数
                              @"userPhone":self.phoneNum,     //  #用户手机号
                              @"token":self.token};       //   #登陆凭证
    [YHWebRequest YHWebRequestForPOST:kWordSubedList parameters:jsonDic success:^(NSDictionary *json) {
        if([json[@"code"] integerValue] == 200){
            NSDictionary *resultDic = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _subedWordList = [NSMutableArray arrayWithArray:resultDic[@"subWordList"]];
            [_tableView reloadData];
        }else{
            NSLog(@"%@",json[@"code"]);
            NSLog(@"%@",json[@"message"]);
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end

//
//  MessageCenterVC.m
//  JYDS
//
//  Created by liyu on 2017/6/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "MessageCenterVC.h"
#import "MessageCenterCell.h"
#import "MessageVC.h"
@interface MessageCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (strong,nonatomic) NSArray *imageArr;
@property (strong,nonatomic) NSArray *imageArr_h;
@property (strong,nonatomic) NSArray *messgaList;
@property (strong,nonatomic) NSString *noticeType;
@property (strong,nonatomic) NSMutableDictionary *oldNoticeCountDic;
@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [YHHud showWithStatus];
    
    _imageArr = @[@"message_sys",@"message_active",@"message_guan"];
    _imageArr_h = @[@"message_sys_h",@"message_active_h",@"message_guan_h"];
    self.view.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [YHWebRequest YHWebRequestForPOST:kNoticeType parameters:nil success:^(NSDictionary *json) {
        [YHHud dismiss];
        if ([json[@"code"] integerValue] == 200) {
            NSDictionary *jsonData = [NSDictionary dictionaryWithJsonString:json[@"data"]];
            _messgaList = jsonData[@"noticeList"];
            [_tableView1 reloadData];
            //第一次加载把每类消息的消息数存本地
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"noticeCountDic"] == nil) {
                NSMutableDictionary *countDic = [[NSMutableDictionary alloc] init];
                for (NSInteger i = 0; i< _messgaList.count; i++) {
                    [countDic setObject:_messgaList[i][@"noticeCount"] forKey:_messgaList[i][@"noticeType"]];
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:countDic] forKey:@"noticeCountDic"];
            }else{
                _oldNoticeCountDic = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"noticeCountDic"]];
            }
        }else{
            NSLog(@"%@",json[@"code"]);
            [YHHud showWithMessage:json[@"message"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [YHHud dismiss];
    }];
    [_tableView1 registerNib:[UINib nibWithNibName:@"MessageCenterCell" bundle:nil] forCellReuseIdentifier:@"MessageCenterCell"];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messgaList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCenterCell" forIndexPath:indexPath];
    NSString *imgStr = @"";
    if ([_messgaList[indexPath.row][@"noticeCount"] integerValue] > 0) {
        if (_oldNoticeCountDic != nil) {
            NSInteger oldNoticeCount = [_oldNoticeCountDic[_messgaList[indexPath.row][@"noticeType"]] integerValue];
            NSInteger newNoticeCount = [_messgaList[indexPath.row][@"noticeCount"] integerValue];
            if (newNoticeCount>oldNoticeCount) {
                imgStr = _imageArr_h[indexPath.row];
            }else{
                imgStr = _imageArr[indexPath.row];
            }
        }else{
            imgStr = _imageArr_h[indexPath.row];
        }
    }else{
        imgStr = _imageArr[indexPath.row];
    }
    cell.messageImage.image = [UIImage imageNamed:imgStr];
    [cell setModel:_messgaList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //覆盖新的消息数并保存本地，
    if (_oldNoticeCountDic != nil) {
        [_oldNoticeCountDic setObject:_messgaList[indexPath.row][@"noticeCount"] forKey:_messgaList[indexPath.row][@"noticeType"]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:_oldNoticeCountDic] forKey:@"noticeCountDic"];
    }
    //去掉小红点
    MessageCenterCell *cell = (MessageCenterCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.messageImage.image = [UIImage imageNamed:_imageArr[indexPath.row]];
    _noticeType = _messgaList[indexPath.row][@"noticeType"];
    [self performSegueWithIdentifier:@"messageCenterToList" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"messageCenterToList"]) {
        MessageVC *messageVC = segue.destinationViewController;
        messageVC.noticeType = _noticeType;
        NSLog(@"%@",_noticeType);
    }
}


@end

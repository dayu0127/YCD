//
//  ExerciseView.m
//  JYDS
//
//  Created by liyu on 2017/1/14.
//  Copyright © 2017年 dayu. All rights reserved.
//

#import "ExerciseView.h"

@implementation ExerciseView

- (instancetype)initWithFrame:(CGRect)frame ExerciseNum:(NSInteger)num level:(NSInteger)level{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        _totalTime = _time = [LEVELARRAY[level] integerValue];
        //标题
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        bgView.backgroundColor = D_CELL_BG;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"练习次数";
        titleLabel.textColor = DGRAYCOLOR;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(bgView.center.x-14, bgView.center.y);
        [bgView addSubview:titleLabel];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.center.x+23, bgView.center.y-11.5, 23, 23)];
        numLabel.layer.masksToBounds = YES;
        numLabel.layer.cornerRadius = 6.0f;
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.backgroundColor = [UIColor darkGrayColor];
        numLabel.text = [NSString stringWithFormat:@"%02zd",num];
        numLabel.textColor = [UIColor whiteColor];
        numLabel.font = [UIFont systemFontOfSize:13.0f];
        [bgView addSubview:numLabel];
        [self addSubview:bgView];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), WIDTH, 1)];
        line.backgroundColor = SEPCOLOR;
        [self addSubview:line];
        
        //mainView
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), WIDTH, frame.size.height-CGRectGetMaxY(line.frame))];
        mainView.backgroundColor = D_BG;
        //time
        UIImage *clock = [UIImage imageNamed:@"exer_clock"];
        UIImageView *clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80*WIDTH/375.0, 48, clock.size.width, clock.size.height)];
        clockImageView.image = clock;
        [mainView addSubview:clockImageView];
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(clockImageView.center.x-36, CGRectGetMaxY(clockImageView.frame)+5, 72, 25)];
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.layer.cornerRadius = 6.0f;
        _timeLabel.backgroundColor = GREEN;
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = [NSString stringWithFormat:@"%@秒",LEVELARRAY[level]];
        [mainView addSubview:_timeLabel];
        //level
        UIImage *levelImage = [UIImage imageNamed:@"exer_level"];
        UIImageView *levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295*WIDTH/375.0-levelImage.size.width, 48, levelImage.size.width, levelImage.size.height)];
        levelImageView.image = levelImage;
        [mainView addSubview:levelImageView];
        UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(levelImageView.center.x-36, CGRectGetMaxY(levelImageView.frame)+5, 72, 25)];
        levelLabel.layer.masksToBounds = YES;
        levelLabel.layer.cornerRadius = 4.0f;
        levelLabel.backgroundColor = GREEN;
        levelLabel.font = [UIFont systemFontOfSize:13.0f];
        levelLabel.textColor = [UIColor whiteColor];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        levelLabel.text = [NSString stringWithFormat:@"等级%zd",level+1];
        [mainView addSubview:levelLabel];
        [self addSubview:mainView];
        
        //生成20对 0到00 的数字(0,1,2,...,9,10,11,...,98,99,00)
        _numArray = [NSMutableArray arrayWithCapacity:20];
        for (NSInteger i = 0; i<20; i++) {
            int num = arc4random()%101;
            if (num == 100) {
                [_numArray addObject:@"00"];
            }else{
                [_numArray addObject:[NSString stringWithFormat:@"%d",num]];
            }
        }
        
        //当前数字
        UIImage *bgImage = [UIImage imageNamed:@"exer_num_bg"];
        UIImageView *currentNumBgImageView = [[UIImageView alloc] initWithImage:bgImage];
        currentNumBgImageView.center = self.center;
        currentNumBgImageView.bounds  = CGRectMake(0, 0, bgImage.size.width, bgImage.size.height);
        [self addSubview:currentNumBgImageView];
        _currentNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgImage.size.width*0.5-40, bgImage.size.height*0.5-28, 80, 56)];
        _currentNumLabel.font = [UIFont systemFontOfSize:56.0f];
        _currentNumLabel.textAlignment = NSTextAlignmentCenter;
        _currentNumLabel.text = _numArray[0];
        _currentNumLabel.textColor = [UIColor whiteColor];
        [currentNumBgImageView addSubview:_currentNumLabel];
        //上一个数字
        _preNumLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(currentNumBgImageView.frame)-24-60, self.center.y-18, 60, 36)];
        _preNumLabel.textColor = SEPCOLOR;
        _preNumLabel.textAlignment = NSTextAlignmentCenter;
        _preNumLabel.font = [UIFont systemFontOfSize:36.0];
        _preNumLabel.layer.shadowColor = RGB(231, 231, 231).CGColor;
        _preNumLabel.layer.shadowOffset = CGSizeMake(-7, 0);
        _preNumLabel.layer.shadowOpacity = 0.8;
        _preNumLabel.layer.shadowRadius = 1.0;
        [self addSubview:_preNumLabel];
        //下一个数字
        _nextNumLabel =  [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentNumBgImageView.frame)+24, self.center.y-18, 60, 36)];
        _nextNumLabel.textColor = SEPCOLOR;
        _nextNumLabel.textAlignment = NSTextAlignmentCenter;
        _nextNumLabel.font = [UIFont systemFontOfSize:36.0];
        _nextNumLabel.text = _numArray[1];
        _nextNumLabel.layer.shadowColor = RGB(231, 231, 231).CGColor;
        _nextNumLabel.layer.shadowOffset = CGSizeMake(7, 0);
        _nextNumLabel.layer.shadowOpacity = 0.8;
        _nextNumLabel.layer.shadowRadius = 1.0;
        [self addSubview:_nextNumLabel];
        //计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _time--;
            _timeLabel.text = [NSString stringWithFormat:@"%zd秒",_time];
            if (_time == 0) {
                [timer invalidate];
                [_delegate showResultView];
            }
        }];
        _timer1 = [NSTimer scheduledTimerWithTimeInterval:_totalTime/20.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            _index++;
            _preNumLabel.text = _numArray[_index-1];
            _currentNumLabel.text = _numArray[_index];
            if (_index != 19) {
                _nextNumLabel.text = _numArray[_index+1];
            }else{
                _nextNumLabel.text = @"";
                [timer invalidate];
            }
        }];
        //pass
        UIButton *passButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH-200)*0.5, frame.size.height-60, 200, 37)];
        passButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [passButton setTitle:@"否" forState:UIControlStateNormal];
        [passButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        passButton.dk_backgroundColorPicker = DKColorPickerWithColors(D_BLUE,N_BLUE,RED);
        passButton.backgroundColor = ORANGERED;
        passButton.layer.masksToBounds = YES;
        passButton.layer.cornerRadius = 6.0f;
        [passButton addTarget:self action:@selector(passClick) forControlEvents:UIControlEventTouchDown];
        [self addSubview:passButton];
    }
    return self;
}
- (void)passClick{
    [_delegate passClick:_numArray[_index]];
}
@end

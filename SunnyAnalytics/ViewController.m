//
//  ViewController.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import "ViewController.h"
#import "SAAnalytics.h"

#define sa_ClassicPage @"page_view_customerInterviewVideo"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - 统计事件

/**
 *  订阅名师
 *
 *  @param sender <#sender description#>
 */
- (IBAction)subTeacher:(UIButton *)sender {
    
        [SAAnalytics doEvent:sub_teacher objectId:nil params:nil];
}

/**
 *  购买视频
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payVideo:(UIButton *)sender {
    
        [SAAnalytics doEvent:pay_video objectId:nil params:nil];
}

/**
 *  象芽充值
 *
 *  @param sender <#sender description#>
 */
- (IBAction)xyChongzhi:(UIButton *)sender {
    
        [SAAnalytics doEvent:pay_user objectId:nil params:nil];
}

/**
 *  订单支付
 *
 *  @param sender <#sender description#>
 */
- (IBAction)payOrder:(UIButton *)sender {
        [SAAnalytics doEvent:pay_order objectId:nil params:nil];
}


/**
 *  注册用户
 *
 *  @param sender <#sender description#>
 */
- (IBAction)registerUser:(UIButton *)sender {
        [SAAnalytics doEvent:reg_user objectId:nil params:nil];
}


/**
 *  实时事件
 *
 *  @param sender <#sender description#>
 */
- (IBAction)onTimeEvent:(UIButton *)sender {
        [SAAnalytics doQuickEvent:@"onTimeEvent" objectId:nil params:nil];
}



#pragma mark - 统计页面
-(void)viewWillAppear:(BOOL)animated
{
    [SAAnalytics beginPage:sa_ClassicPage];
    [super viewWillAppear:animated];
}

#pragma mark - 统计页面
-(void)viewWillDisappear:(BOOL)animated
{
    [SAAnalytics endPage:sa_ClassicPage];
    [super viewWillDisappear:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

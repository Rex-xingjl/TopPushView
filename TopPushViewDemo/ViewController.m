//
//  ViewController.m
//  TopPushViewDemo
//
//  Created by Rex@JJS on 2016/11/22.
//  Copyright © 2016年 Rex@JJSRex. All rights reserved.
//

#import "ViewController.h"
#import "RexPopView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)ShowBtnAction:(id)sender {
    
//    [RexPopView shared].bottomView_color = [UIColor blueColor];
//    [RexPopView shared].bottomView_frame = CGRectMake(0, 40, 100, 30);
//    [RexPopView shared].popView_frame_show = CGRectMake(0, 100, 200, 150);
//    [RexPopView shared].popView_frame_hide = CGRectMake(0, -20, 200, 84);
//    [RexPopView shared].popView_frame = CGRectMake(0, -100, 200, 150);
//    [RexPopView showInfo:@"经纪人桑达棕榈堡分行-尹邦英 报备客户陈佳文-【中海锦城】，请及时接待确认。" btnTitle:@"查看客户"];
//    [RexPopView shared].popView_view_duration = 0;
    
    [RexPopView showInfo:@"经纪人桑达棕榈堡分行-尹邦英 报备客户Rex-【中海锦城】，请及时接待确认。" btnTitle:@"查看客户" btnAction:^{
          NSLog(@"你说说打印不打印呗");
    }];
}

- (IBAction)HideBtnAction:(id)sender {
    
    [RexPopView dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

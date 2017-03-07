//
//  ViewController.m
//  FSLoopScrollViewDemo
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import "ViewController.h"
#import "FSLoopScrollView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    {
        FSLoopScrollView *loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(10, 20, CGRectGetWidth(self.view.bounds)-20, 200) isHorizontal:NO];
        loopView.imgResourceArr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
        loopView.tapClickBlock = ^(FSLoopScrollView *loopView){
            NSString *message = [NSString stringWithFormat:@"老%ld被点啦",(long)loopView.currentIndex+1];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"大顺啊" message:message delegate:self cancelButtonTitle:@"love you" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self.view addSubview:loopView];
    }
    {
        FSLoopScrollView *loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(10, 300, CGRectGetWidth(self.view.bounds)-20, 200) isHorizontal:YES];
        loopView.imgResourceArr = @[@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg",
                                    @"http://img06.tooopen.com/images/20161123/tooopen_sy_187628854311.jpg",
                                    @"http://img07.tooopen.com/images/20170306/tooopen_sy_200775896618.jpg",
                                    @"http://img06.tooopen.com/images/20170224/tooopen_sy_199503612842.jpg",
                                    @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"];
        loopView.tapClickBlock = ^(FSLoopScrollView *loopView){
            NSString *message = [NSString stringWithFormat:@"老%ld被点啦",(long)loopView.currentIndex+1];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"大顺啊" message:message delegate:self cancelButtonTitle:@"love you" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self.view addSubview:loopView];
    }
    {
        FSLoopScrollView *loopView = [FSLoopScrollView loopTitleViewWithFrame:CGRectMake(10, 550, CGRectGetWidth(self.view.bounds)-20, 50) isTitleView:YES titleImgArr:@[@"home_ic_new",@"home_ic_hot",@"home_ic_new",@"home_ic_new",@"home_ic_hot"]];
        loopView.titlesArr = @[@"这是一个简易的文字轮播",
                               @"This is a simple text rotation",
                               @"นี่คือการหมุนข้อความที่เรียบง่าย",
                               @"Это простое вращение текста",
                               @"이것은 간단한 텍스트 회전 인"];
        loopView.tapClickBlock = ^(FSLoopScrollView *loopView){
            NSString *message = [NSString stringWithFormat:@"老%ld被点啦",(long)loopView.currentIndex+1];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"大顺啊" message:message delegate:self cancelButtonTitle:@"love you" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self.view addSubview:loopView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

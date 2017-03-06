//
//  FSLoopScrollView.h
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLoopScrollView : UIView
@property (nonatomic, copy) NSArray *imgResourceArr;
@property (nonatomic, assign) NSTimeInterval timeinterval;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, copy) void (^tapClickBlock)(FSLoopScrollView *loopView);
@end

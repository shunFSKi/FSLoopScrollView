//
//  FSLoopScrollView.m
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import "FSLoopScrollView.h"
#import "NSTimer+FSLoop.h"
#import <UIImageView+WebCache.h>

@interface FSLoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UIImageView *rightImgView;
@property (nonatomic, strong) UIImageView *currentImgView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation FSLoopScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    _leftImgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    _currentImgView.frame = CGRectOffset(_leftImgView.frame, CGRectGetWidth(_leftImgView.bounds), 0);
    
    _rightImgView.frame = CGRectOffset(_currentImgView.frame, CGRectGetWidth(_currentImgView.bounds), 0);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftImgView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_leftImgView];
        
        _rightImgView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_rightImgView];
        
        _currentImgView = [[UIImageView alloc]init];
        [self.scrollView addSubview:_currentImgView];
        
        _timeinterval = 2.0f;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark Action
- (void)onTimer:(NSTimer *)timer
{
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds)*2, 0) animated:YES];
}

- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (self.tapClickBlock) {
        self.tapClickBlock(self);
    }
}

- (void)refreshCurrentImageView
{
    NSInteger index = _currentIndex;
    
    [self dynamicLoadImageView:_currentImgView imageData:self.imgResourceArr[index]];
    
    index = _currentIndex-1<0?self.imgResourceArr.count-1:_currentIndex-1;
    [self dynamicLoadImageView:_leftImgView imageData:self.imgResourceArr[index]];
    
    index = _currentIndex+1>=self.imgResourceArr.count?0:_currentIndex+1;
    [self dynamicLoadImageView:_rightImgView imageData:self.imgResourceArr[index]];
    
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds), 0)];
}

- (void)refreshCurrentIndex
{
    if (self.scrollView.contentOffset.x >= CGRectGetWidth(self.bounds)*1.5) {
        _currentIndex ++;
        if (_currentIndex > self.imgResourceArr.count-1) {
            _currentIndex = 0;
        }
    }else if (self.scrollView.contentOffset.x < CGRectGetWidth(self.bounds)*0.5){
        _currentIndex --;
        if (_currentIndex < 0) {
            _currentIndex = self.imgResourceArr.count-1;
        }
    }
}

- (void)dynamicLoadImageView:(UIImageView *)imageView imageData:(id)data
{
    if ([data isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)data;
    }
    else if ([data isKindOfClass:[NSString class]]){
        NSString *imageName = (NSString *)data;
        if ([imageName hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
}

#pragma mark ----Lazy load

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*3, 0);
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds), 10)];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark setter

-(void)setImgResourceArr:(NSArray *)imgResourceArr
{
    _imgResourceArr = imgResourceArr;
    _currentIndex = 0;
    self.pageControl.numberOfPages = self.imgResourceArr.count;
    self.pageControl.currentPage = 0;
    
    if (![_timer isValid]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [_timer pauseTimer];
    }
    
    if (imgResourceArr.count<=1) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), 0);
    }else{
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) *3, 0);
        [self.timer resumeTimerAfterTimeInterval:_timeinterval];
    }
    
    [self refreshCurrentImageView];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshCurrentIndex];
    if (self.pageControl.currentPage != _currentIndex) {
        self.pageControl.currentPage = _currentIndex;
        [self refreshCurrentImageView];
    }
    
    [self.timer resumeTimerAfterTimeInterval:_timeinterval];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self refreshCurrentIndex];
    if (self.pageControl.currentPage != _currentIndex) {
        self.pageControl.currentPage = _currentIndex;
        [self refreshCurrentImageView];
    }
}

@end

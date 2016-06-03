//
//  ViewController.m
//  CustomSegment
//
//  Created by SmileLife on 16/6/3.
//  Copyright © 2016年 SmileLife. All rights reserved.
//

#import "ViewController.h"
#import "SLCustomSegment.h" //自定义SegMent

#define kHeight      [[UIScreen mainScreen] bounds].size.height
#define kWidth       [[UIScreen mainScreen] bounds].size.width

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

// 颜色(RGB)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface ViewController ()<SLCustomSegmentDelegate,UIScrollViewDelegate>


/**   UI   **/
@property(nonatomic, strong) UIScrollView *newsScrollView;//滑动视图
@property(nonatomic, strong) SLCustomSegment *customSegment;//segment

/**   数据  **/
@property(nonatomic, strong) NSArray *titleArray;//含有所有segment标题的数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setCustomSegmentControl];//设置自定义SegMent
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom SegmetControl

/**
 *  自定义SegMent
 */
- (void)setCustomSegmentControl{
    
    self.automaticallyAdjustsScrollViewInsets = NO; /* 在使用UIScrollView时，这句话必须加上，不然UIScrollView上的视图会不在视野内哦！！！！！！！！！！！！*/
    self.titleArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    
    
    self.customSegment = [[SLCustomSegment alloc]initWithFrame:CGRectMake(0, 64, kWidth, 31) titleArray:self.titleArray];
    self.customSegment.customSegmentDelegaete = self;
    [self.view addSubview:self.customSegment];
    
    [self drawScrollViewSubView];
}


#pragma mark -
#pragma mark - SLCustomSegmentDelegate

/**
 *  点击按钮跳转到相应的界面
 *
 *  @param clickIndex 选中的选项下标
 */

- (void)clickBtnScrollClickViewWithIndex:(NSInteger)clickIndex{
    //在此处理点击按钮时的响应事件
    
    for (UIView *subs in self.newsScrollView.subviews) {
        
        if (subs.tag == clickIndex + 2000) {
            
            [self.newsScrollView setContentOffset:CGPointMake(kWidth * clickIndex, 0) animated:YES];
        }
    }
}


#pragma mark -
#pragma mark - UIScrollView

- (UIScrollView *)newsScrollView{
    
    if (!_newsScrollView) {
        _newsScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 95, kWidth, kHeight - 95)];
        _newsScrollView.pagingEnabled = YES;
        _newsScrollView.delegate = self;
    }
    
    return _newsScrollView;
}

//创建UIScrollView的子视图
- (void)drawScrollViewSubView{
    
    [self.view addSubview:self.newsScrollView];
    
    for (int i = 0; i < self.titleArray.count; i ++) {
        
        CGRect frame = CGRectMake(kWidth * i, 0, WIDTH(self.newsScrollView), HEIGHT(self.newsScrollView));
        NSInteger tag = 2000 + i;
        
        float r = arc4random()%255;
        float g = arc4random()%255;
        float b = arc4random()%255;
        
        UIColor *color  =  RGB(r, g, b, 1);
        
        UIView *subScrollView = [self creatContaineViewWithFrame:frame tag:tag backgroundColor:color];
        [self.newsScrollView addSubview:subScrollView];
    }
    
    
    self.newsScrollView.contentSize = CGSizeMake(kWidth * 10, 0);
}

//创建视图
- (UIView *)creatContaineViewWithFrame:(CGRect)frame tag:(NSInteger)tag backgroundColor:(UIColor *)color{
    
    UIView *subScrollView = [[UIView alloc]initWithFrame:frame];
    subScrollView.backgroundColor = color;
    subScrollView.tag = tag;
    
    return subScrollView;
}


#pragma mark -
#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.newsScrollView) {//确定那一个scrollView移动
        
        NSInteger scrollIndex =  self.newsScrollView.contentOffset.x  / self.newsScrollView.frame.size.width;
        
        
        [self.customSegment dragScrollViewWithSelectIndex:scrollIndex];
        
    }
    
}

@end

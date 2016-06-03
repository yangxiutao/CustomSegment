//
//  SLCustomSegment.m
//  MedicalTreatment
//
//  Created by SmileLife on 16/6/2.
//  Copyright © 2016年 SmileLife. All rights reserved.
//

#import "SLCustomSegment.h" 

#define RectMake(x,y,width,height) CGRectMake(x, y, width, height)

@interface SLCustomSegment ()

@property(nonatomic, assign) CGFloat seletedIndex;//设置选中选项的下标，默认0；
@property(nonatomic, assign) CGFloat selectedWith;//每一个选项的下标
@property(nonatomic, strong) NSArray *titleArray;//标题数组
@property(nonatomic, strong) UIView *bottomLineView;//底部线

@end


@implementation SLCustomSegment


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
    
    
    if ([super initWithFrame:frame]) {
        
        self.titleArray = [NSArray arrayWithArray:titleArray];
        
        //设置每一个Btn的宽度(在View视图中最多显示5个选项)
        if (self.titleArray.count <=5 && self.titleArray.count > 0) {
            self.selectedWith = self.frame.size.width/self.titleArray.count;
            
        }else if (self.titleArray.count > 5){
            self.selectedWith = self.frame.size.width / 5;
        }else{
            self.selectedWith = 0;//没有选项
        }
        
        //设置Btn（Btn的大小 size = CGSizeMake(self.selectedWidth,30) ）
        for (int i = 0; i < self.titleArray.count; i ++) {
            
            NSString *title = [NSString stringWithFormat:@"%@",[self.titleArray objectAtIndex:i]];
            
            CGRect btnFrame = CGRectMake(self.selectedWith * i, 0, self.selectedWith, 30);
            
            NSInteger btnTag = i + 1000;
            
            UIButton *btn = [self setBtnWithFrame:btnFrame title:title tag:btnTag];
            
            [self addSubview:btn];
        }
        self.contentSize = CGSizeMake(self.selectedWith *self.titleArray.count, 0);
        
        //设置默认选中(默认选中第一个,若是修改，只需修改 “self.bottomLineView的frame中x”  和  “selectBtn的tag值” 就可以了)
        self.bottomLineView.frame = RectMake(0 *self.selectedWith, self.frame.size.height - 1, self.selectedWith, 1);
            
        for (UIView *btnView in self.subviews) {
                
            if ([btnView isKindOfClass:[UIButton class]] ) {
                UIButton *selectBtn = (UIButton *)btnView;
                if (selectBtn.tag == 1000) {
                    [selectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
            }
        }
        
        [self addSubview:self.bottomLineView];
    }
    
    return self;
}

#pragma mark -
#pragma mark - 初始化 UIButton

/**
 *  初始化UIButton
 *
 *  @param frame UIButton的位置和大小
 *  @param title UIButton的标题
 *  @param tag   UIButton的tag值
 *
 *  @return UIButton
 */
- (UIButton *)setBtnWithFrame:(CGRect)frame title:(NSString *)title tag:(NSInteger)tag{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frame;
    btn.tag = tag;
    
    //MARK: 在此设置 所有UIButton的字体颜色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

/**
 *  UIButton的响应时间
 *
 *  @param btn 选中的Btn
 */
- (void)btnAction:(UIButton *)btn{
    [self setStatusWithTag:btn.tag];
}




#pragma mark -
#pragma mark - 设置底部的line

- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        
        //MARK: 在此设置 “选中条” 的颜色
        _bottomLineView.backgroundColor = [UIColor blueColor];
    }
    return _bottomLineView;
}



#pragma mark -
#pragma mark - 滑动ScrollView，设置选中的Btn

- (void)dragScrollViewWithSelectIndex:(NSInteger)selectIndex{
    
    [self setStatusWithTag:(1000 + selectIndex)];
}


#pragma mark -
#pragma mark - 设置UIButton和底部选中条的状态

- (void)setStatusWithTag:(NSInteger)tag{
    
    self.seletedIndex = tag - 1000;
    //设置选中Btn的颜色
    for (UIView *btnView in self.subviews) {
        
        if ([btnView isKindOfClass:[UIButton class]] ) {
            UIButton *selectBtn = (UIButton *)btnView;
            if (selectBtn.tag == tag) {
                //MARK: 在此设置 “选中” UIButton的字体颜色
                [selectBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }else{
                //MARK: 在此设置 “未选中” UIButton的字体颜色
                [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
    
    //添加移动动画
    [UIView animateWithDuration:1.0 animations:^{
        
        CGRect frame = self.bottomLineView.frame;
        frame.origin.x = self.selectedWith *self.seletedIndex;
        self.bottomLineView.frame = frame;
    }];
    
    
    //点击按钮跳转到响应界面
    if (self.customSegmentDelegaete || [self.customSegmentDelegaete respondsToSelector:@selector(clickBtnScrollClickViewWithIndex:)]) {
        [self.customSegmentDelegaete clickBtnScrollClickViewWithIndex:self.seletedIndex];
    }
 
    
    if (self.seletedIndex > 3) {
        [self setContentOffset:CGPointMake((self.seletedIndex - 4)*self.selectedWith, 0) animated:YES];
    }
    
}
@end
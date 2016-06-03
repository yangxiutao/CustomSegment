//
//  SLCustomSegment.h
//  MedicalTreatment
//
//  Created by SmileLife on 16/6/2.
//  Copyright © 2016年 SmileLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLCustomSegmentDelegate ;

@interface SLCustomSegment : UIScrollView<UIScrollViewDelegate>

@property(nonatomic, assign) id<SLCustomSegmentDelegate>customSegmentDelegaete;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray; //初始化方法

- (void)dragScrollViewWithSelectIndex:(NSInteger)selectIndex;//滑动ScrollView，设置选中的Btn

@end


@protocol SLCustomSegmentDelegate <NSObject>

@optional

- (void)clickBtnScrollClickViewWithIndex:(NSInteger)clickIndex; //点击按钮

@end
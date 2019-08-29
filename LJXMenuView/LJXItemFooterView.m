//
//  LJXItemFooterView.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/29.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXItemFooterView.h"

@interface LJXItemFooterView()

@property (nonatomic , strong) UIButton * resetBtn;

@property (nonatomic , strong) UIButton * sureBtn;

@end

@implementation LJXItemFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.sureBtn = [UIButton addButtonWithFrame:CGRectMake(DDScreenW - DDFit(12) - DDFit(225), DDFit(15), DDFit(225), DDFit(40)) title:@"确认" titleColor:[UIColor whiteColor] font:DDFontSize(16) image:nil highImage:nil backgroundColor:DDThemeColor tapAction:^(UIButton *button) {
            
            self.ClickBtnBlock(button.tag);
        }];
        
        self.sureBtn.tag = 2001;
        [self addSubview:self.sureBtn];
        
        self.resetBtn = [UIButton addButtonWithFrame:CGRectMake(self.sureBtn.left - DDFit(100), DDFit(15), DDFit(50), DDFit(40)) title:@"重置" titleColor:DDThemeColor font:DDFontSize(16) image:nil highImage:nil backgroundColor:[UIColor whiteColor] tapAction:^(UIButton *button) {
            self.ClickBtnBlock(button.tag);
        }];
        self.resetBtn.tag = 2000;
        self.resetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:self.resetBtn];
        
        [UIView addLineWithFrame:CGRectMake(DDFit(12), 0, DDScreenW - DDFit(12)*2, 0.5) WithView:self];
    }
    return self;
}

@end

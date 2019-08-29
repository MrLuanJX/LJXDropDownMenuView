//
//  LJXSectionItemView.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/29.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXSectionItemView.h"

@implementation LJXSectionItemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.itemLabel = [UILabel addLabelWithFrame:CGRectMake(DDFit(30), 0, DDScreenW - DDFit(60), self.height) title:nil titleColor:UIColorWithRGB(0x383838,1.0) font:DDFontSize(15)];
        
        self.itemLabel.textAlignment = NSTextAlignmentLeft;
        self.itemLabel.text = @"我有";
        [self addSubview: self.itemLabel];
        
        self.topLine = [UIView addLineWithFrame:CGRectMake(DDFit(12), 0, DDScreenW - DDFit(12)*2, 0.5) WithView:self];        
    }
    return self;
}

@end

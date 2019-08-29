//
//  LJXStringFilterTool.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXStringFilterTool.h"

@implementation LJXStringFilterTool

#pragma mark 计算文字的高度
+(CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size FontSize:(UIFont*)font{
    
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}

@end

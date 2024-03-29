//
//  UILabel+Extension.m
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import "UILabel+Extension.h"
#import <CoreText/CoreText.h>

@implementation UILabel (Extension)

+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    label.backgroundColor=[UIColor clearColor];
    
    return label;
}

+ (instancetype)addLabelWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor

                             font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = titleColor;
    label.font = font;
    
    return label;
    
}

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
    
}

/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace
{
//    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

/**
 *  设置删除线
 */
- (void)setCenterLineWithColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length )];
    [str addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = str;
}

/**
 *  设置下划线
 */
- (void)setBottomLineWithColor:(UIColor *)color
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, self.text.length )];
    [str addAttribute:NSStrokeColorAttributeName value:color range:NSMakeRange(0, self.text.length)];
    self.attributedText = str;
}

/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
//    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SYFZLTKHJW--GB1-0" size:14.0] range:NSMakeRange(0, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0,str.length)];
    self.attributedText = str;
    
}

/**
 *  根据宽计算高
 */
- (float)heightWithWidth:(float) width
{
    //调节高度
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    
    CGSize textSize = [self sizeThatFits:maxSize];
    
    return ceil(textSize.height);
    
}

/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor andLength:(NSInteger)length
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.text];
    [str addAttribute:NSFontAttributeName value:DDFontBoldSize(11) range:NSMakeRange(self.text.length - length, length)];
    [str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(self.text.length - length,length)];
    self.attributedText = str;
}

/**
 *  根据高计算宽
 */
- (float)widthWithHeight:(float) height
{
    //调节高度
    CGSize maxSize = CGSizeMake(height, MAXFLOAT);
    
    CGSize textSize = [self sizeThatFits:maxSize];
    
    return ceil(textSize.width);
    
}
/**
 * 根据文字多少和字体大小获取label的size
 @param text 文字
 @param font 字体
 @return label的size
 */
+(CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    CGSize size=[text sizeWithAttributes:attrs];
    return size;
}



@end

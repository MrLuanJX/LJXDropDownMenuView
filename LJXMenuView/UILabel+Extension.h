//
//  UILabel+Extension.h
//  魔颜
//
//  Created by Meiyue on 15/12/16.
//  Copyright © 2015年 abc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

/*算文字尺寸*/
+(CGSize)sizeWithText:(NSString *)text Font:(UIFont *)font;

/**
 *  快速创建Label
 *
 *  @param frame         frame
 *  @param title         文字
 *  @param font          字体
 */

+ (instancetype)addLabelWithFrame:(CGRect)frame
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font;

/**快速创建Label  稍后计算frame*/
+ (instancetype)addLabelWithTitle:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font;

/**
 *  设置字间距
 */
- (void)setColumnSpace:(CGFloat)columnSpace;
/**
 *  设置行距
 */
- (void)setRowSpace:(CGFloat)rowSpace;
/**
 *  设置删除线
   @param color 删除线颜色
 */
- (void)setCenterLineWithColor:(UIColor *)color;
/**
 *  设置下划线
 @param color 删除线颜色
 */
- (void)setBottomLineWithColor:(UIColor *)color;
/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor;

/**
 *  根据宽计算高
 */
- (float)heightWithWidth: (float) width;

/**
 *  根据高计算宽
 */
- (float)widthWithHeight:(float) height;

/**
 *  设置部分字体颜色
 */
- (void)setTextWithColor:(UIColor *)textColor andLength:(NSInteger)length;

@end

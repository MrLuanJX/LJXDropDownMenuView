//
//  LJXStringFilterTool.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJXStringFilterTool : NSObject

/*计算文字高度*/
+(CGSize)computeTextSizeHeight:(NSString*)text Range:(CGSize)size FontSize:(UIFont*)font;


@end

NS_ASSUME_NONNULL_END

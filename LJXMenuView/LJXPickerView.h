//
//  LJXPickerView.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/29.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^confirmAction) (NSString * string);
typedef void (^cancelAction) (void);
typedef void (^maskAction) (void);


@protocol LJXPickerViewDelegate <NSObject>
// 修改箭头方向
- (void) changeArrowDirection:(NSString *) type;

@end

@interface LJXPickerView : UIView

/*
 * 将实现细节封装为一个类方法
 *
 * @param view : 父视图
 * @param dataArray : 数据源
 * @param confirmAction : 点击确认按钮回调的方法
 * @param cancelAction : 点击取消按钮回调的方法
 * @param maskAction : 点击背景回调的方法
 */
+ (instancetype) showPickerViewAddedTo:(UIView *)view
                             dataArray:(NSArray *)dataArray
                           cancelBlock:(cancelAction)cancelBlock
                             maskBlock:(maskAction)maskBlock
                          confirmBlock:(confirmAction)confirmBlock;

@property (nonatomic , weak) id <LJXPickerViewDelegate> changeDelegate;

@end

NS_ASSUME_NONNULL_END

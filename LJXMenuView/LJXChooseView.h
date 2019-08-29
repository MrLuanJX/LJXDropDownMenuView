//
//  LJXChooseView.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXScanTypeView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LJXChooseViewDelegate <NSObject>

@optional

- (void) removeChooseFromwindow;

@end

@interface LJXButtonItem : UIButton

@property (nonatomic , strong) UIImageView * arrowImageView;

@end

@interface LJXChooseView : UIView 
/* itemsTitle */
@property (nonatomic , copy) NSArray * titles;

@property (nonatomic , assign) NSInteger selectedTag;
/* removeDelegate */
@property (nonatomic , weak) id <LJXChooseViewDelegate> removeDelegate;

@property (nonatomic , copy) void (^ChooseItem) (LJXButtonItem * item);

+(LJXChooseView *) shareButtonItemWithFrame:(CGRect) frame itemChooseBlock:(void (^) (LJXButtonItem * item)) chooseBlock;

@end

NS_ASSUME_NONNULL_END

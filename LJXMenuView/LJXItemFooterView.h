//
//  LJXItemFooterView.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/29.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LJXItemFooterView : UICollectionReusableView

@property (nonatomic , copy) void (^ClickBtnBlock) (NSInteger tag);

@end

NS_ASSUME_NONNULL_END

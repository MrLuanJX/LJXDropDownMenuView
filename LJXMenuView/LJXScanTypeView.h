//
//  LJXScanTypeView.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXChooseView.h"
#import "LJXTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LJXScanTypeDelegate <NSObject>

@optional
- (void) changeArrowDirection:(NSString *) type;

@end

@interface ButtonItem : UICollectionViewCell
/* item */
@property (nonatomic , strong) UILabel * itemLabel;
/* 是否被选中 */
@property (nonatomic , assign) BOOL isSelected;
/* model */
@property (nonatomic , strong) LJXTypeModel * typeModel;

@end

@interface LJXScanTypeView : UIView

@property (nonatomic , strong) NSMutableArray * dataSource;

@property (nonatomic , copy) void (^ChooseItem) (ButtonItem * item);

@property (nonatomic , copy) void (^LoanChooseItem) (NSArray* item1 , ButtonItem* item2);

@property (nonatomic , weak) id <LJXScanTypeDelegate> changeDelegate;

+ (instancetype) shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void (^) (ButtonItem * item))chooseBlock LoanItemChooseBlock:(void(^)(NSArray* item1 , ButtonItem* item2))loanChooseBlock;

- (void) scanTypeViewReload;

@end

NS_ASSUME_NONNULL_END

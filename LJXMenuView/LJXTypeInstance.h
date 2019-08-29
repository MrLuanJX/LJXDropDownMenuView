//
//  LJXTypeInstance.h
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LJXTypeModel;
@class ButtonItem;

NS_ASSUME_NONNULL_BEGIN

@interface LJXTypeInstance : NSObject

+ (instancetype) sharedInstance;
/* 贷款类型的分组model */
@property (nonatomic , strong) LJXTypeModel * typeModel;
/* 筛选的贷款类型  筛选的第一个分组 */
@property (nonatomic , strong) NSMutableArray * btnItems;
/* 贷款类型 筛选的第二个分组 */
@property (nonatomic , strong) LJXTypeModel * needModel;
/* 金额筛选 */
@property (nonatomic , copy) NSString * loanMoney;
@end

NS_ASSUME_NONNULL_END

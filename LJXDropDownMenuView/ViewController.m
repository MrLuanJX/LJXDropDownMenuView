//
//  ViewController.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "ViewController.h"
#import "LJXChooseView.h"
#import "LJXTypeModel.h"
#import "LJXScanTypeView.h"
#import "LJXTypeInstance.h"
#import "LJXPickerView.h"

@interface ViewController ()
@property (nonatomic , strong) LJXScanTypeView * scanTypeView;
@property (nonatomic , strong) LJXChooseView * chooseView;
@property (nonatomic , strong) LJXPickerView * pickerView;
@property (nonatomic , strong) NSMutableArray * loanArray;
@property (nonatomic , strong) NSMutableArray * statusArray;

@property (nonatomic , copy) NSString * firstTitle;
@property (nonatomic , copy) NSString * secondTitle;
@property (nonatomic , copy) NSString * thirdTitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [self addChooswView];
}

- (void) addChooswView {
    self.chooseView = [LJXChooseView shareButtonItemWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, DDFit(50)) itemChooseBlock:^(LJXButtonItem * _Nonnull item) {
        [self alertViewWithItem:item];
    }];
    
    self.chooseView.titles = @[@"身份不限",@"金额不限",@"贷款类型"];
    
    [self.view addSubview:self.chooseView];
}



- (void) alertViewWithItem:(LJXButtonItem *)item {
    LJXScanTypeView * scanTypeView = [LJXScanTypeView shareButtonItemWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseView.frame), DDScreenW, DDScreenH-100-DDFit(50)) ItemChooseBlock:^(ButtonItem * _Nonnull item) {
        
        [self dealWithButtonItem:item];
        
    } LoanItemChooseBlock:^(NSArray * _Nonnull item1, ButtonItem * _Nonnull item2) {
        [self loanTypeDidClickDeal:item1 Item:item2];
    }];
    
    self.scanTypeView = scanTypeView;
    scanTypeView.changeDelegate = self.chooseView;
    self.chooseView.removeDelegate = self.scanTypeView;
    if (item.tag == 2000) {
        self.scanTypeView.dataSource = self.loanArray;
        return;
    } else if (item.tag == 2002) {
        self.scanTypeView.dataSource = self.statusArray;
        return;
    } else if (item.tag == 2001) {
        self.pickerView = [LJXPickerView showPickerViewAddedTo:kWindow dataArray:(NSArray *)[self getLoanAmount] cancelBlock:^{
            
        } maskBlock:^{
            
        } confirmBlock:^(NSString * _Nonnull string) {
           
            self.chooseView.titles = @[NULLString(self.firstTitle) ? @"身份类型" : self.firstTitle,string,NULLString(self.thirdTitle) ? @"贷款类型" : self.thirdTitle];
            self.secondTitle = string;
        }];
        
        self.pickerView.changeDelegate = self.chooseView;
    }
}

/* 身份类型回调 */
- (void) dealWithButtonItem:(ButtonItem *)item {
    LJXTypeModel * model = item.typeModel;
    [LJXTypeInstance sharedInstance].typeModel = model;
    self.chooseView.titles = @[model.name,NULLString(self.secondTitle) ? @"金额不限" : self.secondTitle,NULLString(self.thirdTitle) ? @"贷款类型" : self.thirdTitle];
    self.firstTitle = model.name;
    self.chooseView.selectedTag = 0;
}

/* 贷款类型回调 */
-(void)loanTypeDidClickDeal:(NSArray*)items Item:(ButtonItem*)item2{
    ButtonItem * item = items.firstObject;
    NSLog(@"name = %@",item.typeModel.name);
    
    self.chooseView.titles = @[NULLString(self.firstTitle) ? @"身份类型" : self.firstTitle,NULLString(self.secondTitle) ? @"金额不限" : self.secondTitle,NULLString(item.typeModel.name) ? @"贷款类型" : item.typeModel.name];
    self.thirdTitle = item.typeModel.name;
    self.chooseView.selectedTag = 2;
}

- (NSMutableArray *)statusArray {
    if (!_statusArray) {
        _statusArray = @[].mutableCopy;
        LJXTypeModel * typeModel = [[LJXTypeModel alloc] init];
        typeModel.name = @"黑户专享";
        typeModel.code = @"";
        LJXTypeModel * typeModel1 = [[LJXTypeModel alloc] init];
        typeModel1.name = @"银行贷款";
        typeModel1.code = @"";
        LJXTypeModel * typeModel2 = [[LJXTypeModel alloc] init];
        typeModel2.name = @"有信用卡";
        typeModel2.code = @"";
        LJXTypeModel * typeModel3 = [[LJXTypeModel alloc] init];
        typeModel3.name = @"芝麻信用";
        typeModel3.code = @"";
        LJXTypeModel * typeModel4 = [[LJXTypeModel alloc] init];
        typeModel4.name = @"淘宝京东";
        typeModel4.code = @"";
        LJXTypeModel * typeModel5 = [[LJXTypeModel alloc] init];
        typeModel5.name = @"大额专区";
        typeModel5.code = @"";
        LJXTypeModel * typeModel6 = [[LJXTypeModel alloc] init];
        typeModel6.name = @"不上征信";
        typeModel6.code = @"";
        [_statusArray addObject:@{@"我有":[NSMutableArray arrayWithObjects:typeModel,typeModel1,typeModel2,typeModel3,typeModel4,typeModel5,typeModel6, nil]}];
        LJXTypeModel * typeModel7 = [[LJXTypeModel alloc] init];
        typeModel7.name = @"一次还清";
        typeModel7.code = @"";
        LJXTypeModel * typeModel8 = [[LJXTypeModel alloc] init];
        typeModel8.name = @"分期还清";
        typeModel8.code = @"";
        
        [_statusArray addObject:@{@"我需要":[NSMutableArray arrayWithObjects:typeModel7,typeModel8, nil]}];
    }
    return _statusArray;
}

- (NSMutableArray *)loanArray {
    if (!_loanArray) {
        _loanArray = @[].mutableCopy;
        LJXTypeModel * typeModel = [[LJXTypeModel alloc] init];
        typeModel.name = @"身份不限";
        typeModel.code = @"";
        LJXTypeModel * typeModel1 = [[LJXTypeModel alloc] init];
        typeModel1.name = @"资金周转";
        typeModel1.code = @"";
        LJXTypeModel * typeModel2 = [[LJXTypeModel alloc] init];
        typeModel2.name = @"日常消费";
        typeModel2.code = @"";
        LJXTypeModel * typeModel3 = [[LJXTypeModel alloc] init];
        typeModel3.name = @"大额低息";
        typeModel3.code = @"";
        LJXTypeModel * typeModel4 = [[LJXTypeModel alloc] init];
        typeModel4.name = @"小额秒批";
        typeModel4.code = @"";
        [_loanArray addObject:@{@"one":[NSMutableArray arrayWithObjects:typeModel,typeModel1,typeModel2,typeModel3,typeModel4, nil]}];
    }
    return _loanArray;
}

/* 获取金额筛选文件内容 */
- (NSMutableArray *) getLoanAmount {
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"loan" ofType:@"plist"];
    NSMutableArray * loanArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    return loanArray;
}

@end

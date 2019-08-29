//
//  LJXPickerView.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/29.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXPickerView.h"

@interface LJXPickerView () <UIGestureRecognizerDelegate , UIPickerViewDelegate , UIPickerViewDataSource>

@property (nonatomic , strong) UIPickerView * pickerView;

@property (nonatomic , strong) UIView * containerView;

@property (nonatomic , strong) UIButton * confirmButton;

@property (nonatomic , strong) UIButton * cancelButton;

@property (nonatomic , copy) NSArray * dataArray;

@property (nonatomic , copy) cancelAction cancelBlock;

@property (nonatomic , copy) maskAction maskBlock;

@property (nonatomic , copy) confirmAction confirmBlock;

@end

@implementation LJXPickerView

const int pickerViewHeight = 200;

+ (instancetype) showPickerViewAddedTo:(UIView *)view
                             dataArray:(NSArray *)dataArray
                           cancelBlock:(cancelAction)cancelBlock
                             maskBlock:(maskAction)maskBlock
                          confirmBlock:(confirmAction)confirmBlock {
    
    LJXPickerView * pickerView = [[LJXPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    // 设置属性
    pickerView.cancelBlock = cancelBlock;
    pickerView.maskBlock = maskBlock;
    pickerView.confirmBlock = confirmBlock;
    
    pickerView.dataArray = dataArray;
    
    // 淡出动画
    pickerView.alpha = 0;
    pickerView.containerView.frame = CGRectMake(0, DDScreenH, DDScreenW, pickerViewHeight);
    [view addSubview:pickerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerView.containerView.frame = CGRectMake(0,DDScreenH - pickerViewHeight, DDScreenW, pickerViewHeight);
        pickerView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    return pickerView;
}

- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        UITapGestureRecognizer *  tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClickAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        [self layoutViews];
    }
    return self;
}

- (void) layoutViews {
    self.containerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - pickerViewHeight, [UIScreen mainScreen].bounds.size.width, pickerViewHeight);
    
    [self addSubview:self.containerView];
}

- (void) containerViewLayoutViews {
    self.pickerView.frame = CGRectMake(0, 30, [UIScreen mainScreen].bounds.size.width, pickerViewHeight - 30);
    
    [self.containerView addSubview: self.pickerView];
    
    /* ToolView */
    UIView * bgView = [UIView CreateViewWithFrame:CGRectMake(0, 0, DDScreenW, 40) BackgroundColor:DDThemeColor InteractionEnabled:YES];
    [self.containerView addSubview:bgView];
    // 取消
    self.cancelButton.frame = CGRectMake(15, 0, 40, 40);
    [self.containerView addSubview:self.cancelButton];
    // 确定
    self.confirmButton.frame = CGRectMake(DDScreenW - 40 - 15, 0, 40, 40);
    [self.containerView addSubview:self.confirmButton];
}

#pragma mark - dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count > 0 ? self.dataArray.count : 0;
}
#pragma mark - delegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    /* 设置分割线颜色 */
    for (UIView *singleLine in pickerView.subviews) {
        if (singleLine.height < 1) {
            singleLine.backgroundColor = DDLineColor;
        }
    }
    
    /* 设置文字属性 */
    UILabel * genderLabel = [UILabel new];
    genderLabel.font = DDFontSize(17);
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.textColor = [UIColor colorWithWhite:0 alpha:0.87];
    genderLabel.text = self.dataArray[row];
    
    return genderLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return DDFit(30);
}

/* 点击背景 */
- (void) backgroundClickAction {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
            [self.changeDelegate changeArrowDirection:@"0"];
        }
        self.maskBlock();
        [self removeFromSuperview];
    }];
}
/* 取消 */
- (void) cancelAction {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
            [self.changeDelegate changeArrowDirection:@"0"];
        }
        self.cancelBlock();
        [self removeFromSuperview];
    }];
}

/* 确定 */
- (void) confrimAction {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
            [self.changeDelegate changeArrowDirection:@"1"];
        }
        self.confirmBlock(self.dataArray[[self.pickerView selectedRowInComponent:0]]);
        [self removeFromSuperview];
    }];
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        
        [self containerViewLayoutViews];
    }
    return _containerView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton ) {
        _confirmButton = [UIButton new];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confrimAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

/* 点击范围 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(self.pickerView.frame, point)) {
        return NO;
    }
    return YES;
}

@end

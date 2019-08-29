//
//  LJXChooseView.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXChooseView.h"

@interface LJXButtonItem ()

@end

@implementation LJXButtonItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.arrowImageView = [[UIImageView alloc]init];
        UIImage * image = [UIImage imageNamed:@"下拉箭头"];
        self.arrowImageView.image = image;
        self.arrowImageView.size = image.size;
        [self addSubview: self.arrowImageView];
        
        _arrowImageView.y = (self.height - image.size.height)/2;
        _arrowImageView.x = self.width;
    }
    return self;
}

@end


@interface LJXChooseView () <LJXScanTypeDelegate>

@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;
@property (nonatomic , assign) CGFloat edgeX;
@property (nonatomic , assign) CGFloat offsetX;
/* 当前点击的item */
@property (nonatomic , strong) LJXButtonItem * currentItem;
/* 上一次点击的item */
@property (nonatomic , strong) LJXButtonItem * lastItem;

@end

@implementation LJXChooseView

+(LJXChooseView *) shareButtonItemWithFrame:(CGRect) frame itemChooseBlock:(void (^) (LJXButtonItem * item)) chooseBlock {
    
    return [[LJXChooseView alloc] initWithFrame:frame itemChooseBlock:chooseBlock];
}

- (instancetype) initWithFrame:(CGRect)frame itemChooseBlock:(void (^) (LJXButtonItem * item)) chooseBlock {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        
        self.width = DDFit(66);
        self.height = DDFit(50);
        self.edgeX = DDFit(24);
        self.offsetX = (DDScreenW - self.edgeX*2 - self.width*3)/2;
        
        self.ChooseItem = chooseBlock;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    
    // 1.先移除所有视图
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0; i < titles.count; i++) {
        LJXButtonItem * buttonItem = [[LJXButtonItem alloc] initWithFrame:CGRectMake(self.edgeX+i*(self.offsetX+self.width), 0, self.width, self.height)];
        [buttonItem setTitle:titles[i] forState:UIControlStateNormal];
        [buttonItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [buttonItem setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        buttonItem.titleLabel.font = DDFontSize(14);
        buttonItem.tag = i + 2000;
        [buttonItem addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
//        buttonItem.backgroundColor = [UIColor yellowColor];
        [self addSubview: buttonItem];
    }
}

- (void)setSelectedTag:(NSInteger)selectedTag {
    _selectedTag = selectedTag;
    
    LJXButtonItem * selectedItem = [self viewWithTag:2000+selectedTag];
    
    self.currentItem = selectedItem;
}

- (void) itemAction: (LJXButtonItem *) item {
    
    NSLog(@"点击按钮");
    
    if ([item isEqual:self.currentItem] && [self.currentItem.arrowImageView.image isEqual:[UIImage imageNamed:@"上拉箭头"]]) {
        /* 重复点击同一个按钮 改变状态 移除下拉视图 */
        if (self.removeDelegate && [self.removeDelegate respondsToSelector:@selector(removeChooseFromwindow)]) {
            [self.removeDelegate removeChooseFromwindow];
        }
        self.currentItem.arrowImageView.image = [UIImage imageNamed:@"下拉箭头"];
        return;
    }
    
    if (![item isEqual:self.currentItem]) {
        if (self.removeDelegate && [self.removeDelegate respondsToSelector:@selector(removeChooseFromwindow)]) {
            [self.removeDelegate removeChooseFromwindow];
        }
    }
    
    self.currentItem.selected = NO;
    self.currentItem.arrowImageView.image = [UIImage imageNamed:@"下拉箭头"];
    self.currentItem = item;
    self.currentItem.selected = YES;
    self.currentItem.arrowImageView.image = [UIImage imageNamed:@"上拉箭头"];

    if (self.ChooseItem) {
        self.ChooseItem(item);
    }
}

- (void) changeArrowDirection:(NSString *) type {
    self.currentItem.arrowImageView.image = [UIImage imageNamed:@"下拉箭头"];
    self.currentItem.selected = NO;
}

@end

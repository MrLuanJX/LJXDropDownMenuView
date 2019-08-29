//
//  LJXScanTypeView.m
//  LJXDropDownMenuView
//
//  Created by 栾金鑫 on 2019/8/28.
//  Copyright © 2019年 栾金鑫. All rights reserved.
//

#import "LJXScanTypeView.h"
#import "LJXTypeInstance.h"
#import "LJXStringFilterTool.h"
#import "LJXSectionItemView.h"
#import "LJXItemFooterView.h"

@interface ButtonItem ()

@property (nonatomic , strong) UILabel * item;

@end

@implementation ButtonItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.itemLabel = [UILabel addLabelWithFrame:CGRectMake(0, 0, self.width, DDFit(28)) title:nil titleColor:[UIColor whiteColor] font:DDFontSize(14)];
        self.itemLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = DDFit(14);
        self.clipsToBounds = YES;
        [self.contentView addSubview: self.itemLabel];
    }
    return self;
}

- (void)setTypeModel:(LJXTypeModel *)typeModel {
    _typeModel = typeModel;
    
    self.itemLabel.text = typeModel.name;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        self.backgroundColor = DDThemeColor;
        self.itemLabel.textColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.itemLabel.textColor = UIColorWithRGB(0x393939, 1.0);;
    }
}

@end

@interface LJXScanTypeView () <LJXChooseViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic , strong) UICollectionView * collectionView;

/* 第一组当前选中的  用来删除Item项*/
@property(nonatomic,strong) ButtonItem * firstCurrentItem;
/* 第一组当前选中的*/
@property(nonatomic,strong) ButtonItem * secondCurrentItem;

@end

@implementation LJXScanTypeView

+ (instancetype) shareButtonItemWithFrame:(CGRect)frame ItemChooseBlock:(void (^) (ButtonItem * item))chooseBlock LoanItemChooseBlock:(void(^)(NSArray* item1 , ButtonItem* item2))loanChooseBlock {
    return [[LJXScanTypeView alloc] initWithFrame:frame ItemChooseBlock:chooseBlock LoanItemChooseBlock:loanChooseBlock];
}

- (instancetype)initWithFrame:(CGRect)frame ItemChooseBlock:(void (^) (ButtonItem * item))chooseBlock LoanItemChooseBlock:(void(^)(NSArray* item1 , ButtonItem* item2))loanChooseBlock {
    
    if (self = [super initWithFrame:frame]) {
        
        self.height = DDScreenH - 100 - DDFit(50);
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.ChooseItem = chooseBlock;
        self.LoanChooseItem = loanChooseBlock;
        
        [UIView addLineWithFrame:CGRectMake(0, 0.5, self.width, 0.5) WithView:self];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInWindow)];
        [self addGestureRecognizer:tap];
        tap.delegate = self;
    }
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource {
    _dataSource = dataSource;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.y = 100 + DDFit(50);
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [kWindow addSubview:self];
        [self.collectionView reloadData];
    }];
}

- (void) removeChooseFromwindow {
    [self hideInWindow];
}

- (void) hideInWindow {
    if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
        [self.changeDelegate changeArrowDirection:@"0"];
    }
    [self removeItemInWindow];
}

- (void) removeItemInWindow {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    
    if (CGRectContainsPoint(self.collectionView.frame, point)) {
        return NO;
    }
    return YES;
}

#pragma mark - collectionViewDelegate、collectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource.count > section) {
        NSString * key = [[((NSDictionary*)[self.dataSource objectAtIndex:section])allKeys] firstObject];
        NSArray * sectionTitle = [((NSDictionary *)[self.dataSource objectAtIndex:section]) objectForKey:key];
        
        return sectionTitle.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ButtonItem * gridCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buttonItem" forIndexPath:indexPath];
    
    if (self.dataSource.count > indexPath.section) {
        NSString * key = [[(NSDictionary *)[self.dataSource objectAtIndex:indexPath.section] allKeys] firstObject];
        NSArray * sectionTitle = [(NSDictionary *)[self.dataSource objectAtIndex:indexPath.section] objectForKey:key];
        
        NSString * name = ((LJXTypeModel *)[sectionTitle objectAtIndex:indexPath.item]).name;
        gridCell.typeModel = (LJXTypeModel *)[sectionTitle objectAtIndex:indexPath.item];
        gridCell.itemLabel.text = name;
        
        if (self.dataSource.count == 1) {
            gridCell.isSelected = [self shouldSelectedAtIndexPath:indexPath Name:name];
        } else {
            gridCell.isSelected = [self resetItem:gridCell IndexPath:indexPath];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.collectionView.height = collectionView.contentSize.height;
        }];
    }
    
    return gridCell;
}
/* sectionHead 宽高 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return self.dataSource.count == 1 ? CGSizeZero : CGSizeMake(self.width, DDFit(55));
}

/* footer 宽高 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return self.dataSource.count == 1 ? CGSizeZero : (section == 0) ? CGSizeZero : CGSizeMake(DDScreenW, DDFit(72));
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        LJXSectionItemView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        if (self.dataSource.count > indexPath.section) {
            NSString * key = [[((NSDictionary *) [self.dataSource objectAtIndex:indexPath.section]) allKeys] firstObject];
            headerView.itemLabel.text = key;
        }
        
        headerView.topLine.hidden = !indexPath.section;
        
        return headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        LJXItemFooterView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView" forIndexPath:indexPath];
        
        footerView.ClickBtnBlock = ^(NSInteger tag) {
            
            if (tag == 2000) {
                // 重置
                [self resetAllItems];
                if (self.LoanChooseItem) {
                    self.LoanChooseItem([LJXTypeInstance sharedInstance].btnItems, self.secondCurrentItem);
                }
                // 修改箭头方向
                if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
                    [self.changeDelegate changeArrowDirection:@"1"];
                }
                [self removeItemInWindow];
            }
            
            if (tag == 2001) {
                // 确定
                // 修改箭头方向
                if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
                    [self.changeDelegate changeArrowDirection:@"1"];
                }
                // 回调
                if (self.LoanChooseItem) {
                    self.LoanChooseItem([LJXTypeInstance sharedInstance].btnItems, self.secondCurrentItem);
                }
                [self removeItemInWindow];
            }
        };
        
        return footerView;
    }
    
    return nil;
}

#pragma mark - 重置所有筛选
- (void) resetAllItems {
    for (ButtonItem * item in self.collectionView.visibleCells) {
        item.selected = NO;
        [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:item] animated:YES];
    }
    /* 全部删除 */
    [[LJXTypeInstance sharedInstance].btnItems removeAllObjects];
    [LJXTypeInstance sharedInstance].needModel = nil;
    self.firstCurrentItem = nil;
    self.secondCurrentItem = nil;
    
}

#pragma mark 是否应该被选中
- (BOOL) shouldSelectedAtIndexPath:(NSIndexPath *)indexPath Name:(NSString *)name {
    if ([LJXTypeInstance sharedInstance].typeModel.name.length == 0 ) {
        if (self.dataSource.count == 1 && indexPath.row == 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        if ([[LJXTypeInstance sharedInstance].typeModel.name isEqualToString:name]) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}
/* item宽高 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = CGSizeZero;
    
    if (self.dataSource.count > indexPath.section) {
        NSString * key = [[((NSDictionary *)[self.dataSource objectAtIndex:indexPath.section])allKeys] firstObject];
        NSArray * sectionTitle = [(NSDictionary *)[self.dataSource objectAtIndex:indexPath.section] objectForKey:key];
        NSString * name = ((LJXTypeModel *)[sectionTitle objectAtIndex:indexPath.row]).name;
        CGFloat width = [LJXStringFilterTool computeTextSizeHeight:name Range:CGSizeMake(MAXFLOAT, DDFit(28)) FontSize:DDFontSize(14)].width;
        itemSize = CGSizeMake(width + DDFit(24), DDFit(28));
    }
    return itemSize;
}

/* x间距 */
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat value = (DDScreenW - 4 * DDFit(75) - 2 * DDFit(20))/3;
    
    return value;
}

/* y间距 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    CGFloat value = DDFit(18);
    
    return value;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(DDFit(18), DDFit(20), DDFit(18), DDFit(20));
}

/* 点击item */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self itemDidSelect:(ButtonItem *)[collectionView cellForItemAtIndexPath:indexPath] AtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self itemDidSelect:(ButtonItem *)[collectionView cellForItemAtIndexPath:indexPath] AtIndexPath:indexPath];
}

/* item点击 */
- (void) itemDidSelect:(ButtonItem *)item AtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count == 1) {
        /* 修改箭头方向 */
        if (self.changeDelegate && [self.changeDelegate respondsToSelector:@selector(changeArrowDirection:)]) {
            [self.changeDelegate changeArrowDirection:@"1"];
        }
        /* 回调值 */
        if (self.ChooseItem) {
            self.ChooseItem(item);
        }
        
        [self removeItemInWindow];
        
        [self scanTypeViewReload];
        
        return;
    }
    
    if (self.dataSource.count == 2) {
        
        if (indexPath.section == 0) {
            
            // 先查找需要反选的
            [self deselcteItem:item];
            
        } else {
            if ([item.itemLabel.text isEqualToString:self.secondCurrentItem.itemLabel.text]) {
                self.secondCurrentItem.isSelected = NO;
                [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES];
                self.secondCurrentItem = nil;
                [LJXTypeInstance sharedInstance].needModel = nil;
            } else {
                [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES];
                self.secondCurrentItem.isSelected = NO;
                self.secondCurrentItem = item;
                [self.collectionView selectItemAtIndexPath:[self.collectionView indexPathForCell:self.secondCurrentItem] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                self.secondCurrentItem.isSelected = YES;
                [LJXTypeInstance sharedInstance].needModel = self.secondCurrentItem.typeModel;
            }
        }
    }
}

#pragma mark - 重置效果
- (BOOL) resetItem:(ButtonItem *) item IndexPath:(NSIndexPath *)indexPath {
    BOOL isSelected = NO;
    
    switch (indexPath.section) {
        case 1:
            if ([[LJXTypeInstance sharedInstance].needModel.name isEqualToString:item.typeModel.name]) {
                isSelected = YES;
                
                // 获取上一次选中的cell
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                } completion:^(BOOL finished) {
                    self.secondCurrentItem = (ButtonItem *)[self.collectionView cellForItemAtIndexPath:indexPath];
                }];
                return isSelected;
            }
            break;
            
        case 0:
            for (ButtonItem * INItem in [LJXTypeInstance sharedInstance].btnItems) {
                if ([INItem.itemLabel.text isEqualToString:item.itemLabel.text]) {
                    isSelected = YES;
                }
            }
            break;
        default:
            break;
    }
    
    return isSelected;
}

#pragma mark - 查找当前点击的进行反选
- (void) deselcteItem:(ButtonItem *)item {
    BOOL isSame=NO;
    for(ButtonItem * InItem in [LJXTypeInstance sharedInstance].btnItems){
        
        if ([InItem.itemLabel.text isEqualToString:item.itemLabel.text]) {
            
            [self.collectionView deselectItemAtIndexPath:[self.collectionView indexPathForCell:item] animated:YES];
            InItem.isSelected = NO;
            self.firstCurrentItem = InItem;
            isSame = YES;
        }
    }
    if (!isSame) {
        [[LJXTypeInstance sharedInstance].btnItems addObject:item];
        [self.collectionView selectItemAtIndexPath:[self.collectionView indexPathForCell:item] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        item.isSelected = YES;
    }else{
        [[LJXTypeInstance sharedInstance].btnItems removeObject:self.firstCurrentItem];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = DDFit(5);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DDScreenW, DDFit(80)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[ButtonItem class] forCellWithReuseIdentifier:@"buttonItem"];
        [_collectionView registerClass:[LJXSectionItemView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
        [_collectionView registerClass:[LJXItemFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerView"];
        [self addSubview: _collectionView];
    }
    return _collectionView;
}

- (void) scanTypeViewReload {
    [self.collectionView reloadData];
}

@end

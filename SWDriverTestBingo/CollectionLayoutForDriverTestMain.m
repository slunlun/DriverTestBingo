//
//  FlowLayoutForPageTest.m
//  CollectionViewLayoutTest
//
//  Created by ShiTeng on 15/8/22.
//  Copyright (c) 2015年 ShiTeng. All rights reserved.
//

#import "CollectionLayoutForDriverTestMain.h"
#define MAIN_CELL_WIDTH   ([UIScreen mainScreen].bounds.size.width - 3)/2
#define MAIN_CELL_HEIGHT  ([UIScreen mainScreen].bounds.size.width - 3)/3

#define NORMAL_CELL_WIDTH  ([UIScreen mainScreen].bounds.size.width - 3)/2
#define NORMAL_CELL_HEIGHT ([UIScreen mainScreen].bounds.size.width - 3)/3

#define SECTION_HEIGHT 40

@interface CollectionLayoutForDriverTestMain()
@property(nonatomic, strong) NSMutableDictionary *cellLayoutAttrDic;
@end
@implementation CollectionLayoutForDriverTestMain

#pragma SETTER/GETTER
-(NSMutableDictionary *) cellLayoutAttrDic
{
    if (_cellLayoutAttrDic == nil) {
        _cellLayoutAttrDic = [[NSMutableDictionary alloc] init];
    }
    
    return _cellLayoutAttrDic;
}
#pragma mark layout support method
-(void) initCellAttrArray
{
    CGRect cellFrame;
    //Cell 0,0 (section, row)
    NSIndexPath *mainCellIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    cellFrame = CGRectMake(1, SECTION_HEIGHT + 1, MAIN_CELL_WIDTH,MAIN_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:mainCellIndex forKey:NSStringFromCGRect(cellFrame)];
    
    //Cell 0,1
    NSIndexPath *subCellOneIndex = [NSIndexPath indexPathForItem:1 inSection:0];
    cellFrame = CGRectMake(MAIN_CELL_WIDTH + 2, SECTION_HEIGHT + 1, MAIN_CELL_WIDTH, MAIN_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:subCellOneIndex forKey:NSStringFromCGRect(cellFrame)];
    
    //Cell 0, 2
    NSIndexPath *subCellThreeIndex = [NSIndexPath indexPathForItem:2 inSection:0];
    cellFrame = CGRectMake(1, SECTION_HEIGHT + MAIN_CELL_HEIGHT + 2, MAIN_CELL_WIDTH, MAIN_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:subCellThreeIndex forKey:NSStringFromCGRect(cellFrame)];
    
    //Cell 0,3
    NSIndexPath *subCellFourIndex = [NSIndexPath indexPathForItem:3 inSection:0];
    cellFrame = CGRectMake(MAIN_CELL_WIDTH + 2, SECTION_HEIGHT + MAIN_CELL_HEIGHT + 2, MAIN_CELL_WIDTH, MAIN_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:subCellFourIndex forKey:NSStringFromCGRect(cellFrame)];
    
    // normal cell 1
    NSIndexPath *normalCellOneIndex = [NSIndexPath indexPathForItem:0 inSection:1];
    cellFrame = CGRectMake(1, SECTION_HEIGHT * 2 + MAIN_CELL_HEIGHT*2+ 1, NORMAL_CELL_WIDTH, NORMAL_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:normalCellOneIndex forKey:NSStringFromCGRect(cellFrame)];
    // normal cell 2
    NSIndexPath *normalCellTowIndex = [NSIndexPath indexPathForItem:1 inSection:1];
    cellFrame = CGRectMake(NORMAL_CELL_WIDTH + 2, SECTION_HEIGHT * 2 + MAIN_CELL_HEIGHT*2 + 1, NORMAL_CELL_WIDTH, NORMAL_CELL_HEIGHT);
    [self.cellLayoutAttrDic setObject:normalCellTowIndex forKey:NSStringFromCGRect(cellFrame)];
}

- (NSArray *)indexPathsOfItem:(CGRect)rect{
    //遍历布局字典通过CGRectIntersectsRect方法确定每个cell的rect与传入的rect是否有交集，如果结果为true，则此cell应该显示，将布局字典中对应的indexPath加入数组
    NSLog(@"indexPathsOfItem");
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *rectStr in self.cellLayoutAttrDic) {
        CGRect cellRect = CGRectFromString(rectStr);
        if (CGRectIntersectsRect(cellRect, rect)) {
            NSIndexPath *indexPath = self.cellLayoutAttrDic[rectStr];
            [array addObject:indexPath];
        }
    }
    return array;
}

#pragma mark overwrite super method
-(void) prepareLayout
{
    [super prepareLayout];
    self.delegate = self.collectionView.delegate;
    [self initCellAttrArray];
    
}
// In ios7 and below , we must imply collectionViewContentSize, to tell IOS the content size of collectionview
- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSLog(@"layoutAttributesForElementsInRect");
    [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *muArr = [NSMutableArray array];
    //indexPathsOfItem方法，根据传入的frame值计算当前应该显示的cell
    NSArray *indexPaths = [self indexPathsOfItem:rect];
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        [muArr addObject:attribute];
    }
    return muArr;
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
   
    for (NSString *rectStr in self.cellLayoutAttrDic) {
        if (self.cellLayoutAttrDic[rectStr] == indexPath) {
            layoutAttr.frame = CGRectFromString(rectStr);
            break;
        }
    }
    return layoutAttr;
}
@end

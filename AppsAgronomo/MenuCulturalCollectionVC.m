//
//  MenuCulturalCollectionVC.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 13/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "MenuCulturalCollectionVC.h"
#import "MenuCulturalCollectionCell.h"

@implementation MenuCulturalCollectionVC

static NSString * const reuseIdentifier = @"Cell";

const CGFloat leftAndRightPaddings = 32.0;
const CGFloat numberOfItemsPerRow = 2.0;
const CGFloat heigthAdjustment = 70.0;

CGFloat width = 0.0;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat varWidth = [UIScreen mainScreen].bounds.size.width;
    width = ((varWidth - leftAndRightPaddings) / numberOfItemsPerRow);
    
    MenuCultural = @[@"CINEMA", @"EVENTOS", @"MÚSICAS", @"TEATRO", @"LITERATURA"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@", [MenuCultural objectAtIndex:indexPath.row]);
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return MenuCultural.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCulturalCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // add a border
    
    
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.layer setBorderWidth:1.0];
    cell.layer.cornerRadius = 3; // optional
    
    cell.layer.shadowOffset = CGSizeMake(4, 4);
    cell.layer.shadowOpacity = 0.5;
    cell.layer.shadowRadius = 4.0;
    
    cell.lbDescricaoCultural.text = [MenuCultural objectAtIndex:indexPath.row];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(width, width + heigthAdjustment);
}

@end

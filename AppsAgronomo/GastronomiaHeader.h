//
//  GastronomiaHeader.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 25/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GastronomiaHeader : UITableViewCell <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbEstabelecimento;
@property (weak, nonatomic) IBOutlet UIButton *btnFotos;

@end

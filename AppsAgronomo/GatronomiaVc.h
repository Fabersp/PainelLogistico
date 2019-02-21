//
//  GatronomiaVc.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 11/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface GatronomiaVc : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate> {
    
    NSString * idView, * NumMenu, * Endereco, * onde, * telefone, *estabelecimento, * texto;
    
    NSArray * lista, * horarios, * fotos;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSMutableArray * _selections;
    NSURL * UrlImagem;
    
    UIImageView *imgView;
    
    
}
@property (weak, nonatomic) IBOutlet UITextView *txt_SnopseRestaurante;

@property (weak, nonatomic) IBOutlet UIView *viewSinopseRest;
@property (nonatomic, retain) NSString * idView, * NumMenu, * Endereco, * onde, * telefone, * estabelecimento, * texto;

@property (nonatomic, retain) NSURL * UrlImagem;

@property (nonatomic, retain) IBOutlet UIImageView *imgView;



@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *imageArray;



@property (weak, nonatomic) IBOutlet UITableView *table;

@end

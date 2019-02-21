//
//  MenuGastronomia.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 24/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface MenuGastronomia : UICollectionViewController {
    
    NSArray * listaManu;
    NSDictionary * ObjetoJson;
    
    NSString * Id_Menu;
    
    
    Reachability * internetReachable;
    Reachability * hostReachable;
    bool internetActive;
    bool hostActive;
    
    UIView * viewHeader;

}

@property (nonatomic, retain) NSDictionary * ObjetoJson;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;


@property (strong, nonatomic) NSString * Id_Menu;



@end

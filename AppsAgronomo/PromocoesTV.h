//
//  PromocoesTV.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 27/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "Reachability.h"


@interface PromocoesTV : UITableViewController {
    
    NSArray * lista, * vigencias;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    NSURL  * urlImage;
    
    
}




@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;





    
    
    


@end

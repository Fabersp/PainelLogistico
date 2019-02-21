//
//  MenuCultural.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 16/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "Reachability.h"



@interface MenuCultural : UITableViewController {
    
    NSArray * ListaCultural;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
    UIView * viewHeader;
    NSDictionary * ObjetoJson;
    NSInteger numMenu;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;

@property (weak, nonatomic) IBOutlet UIView *viewTop;



@end

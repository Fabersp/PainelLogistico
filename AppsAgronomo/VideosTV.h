//
//  VideosTV.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 27/07/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "Reachability.h"

@interface VideosTV : UITableViewController {
    
    NSArray * lista;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;

    
}




@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;


@end

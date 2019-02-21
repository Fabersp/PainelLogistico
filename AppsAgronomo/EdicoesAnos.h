//
//  EdicoesAnos.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 09/08/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface EdicoesAnos : UITableViewController {
    
    NSArray * Categorias;
    NSDictionary * ObjetoJson;
    Reachability* internetReachable;
    Reachability* hostReachable;
    bool internetActive;
    bool hostActive;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;


@end

//
//  MenuSobre.h
//  AppsAgronomo
//
//  Created by Fabricio Padua on 19/08/15.
//  Copyright (c) 2015 Fabricio Padua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>

@interface MenuSobre : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *ViewApper;


@end

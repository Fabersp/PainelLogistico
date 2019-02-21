//
//  ViewContato.h
//  SidebarDemo
//
//  Created by Fabricio Aguiar de Padua on 08/05/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>


@interface ViewContato : UIViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIView *ViewApper;

@property (weak, nonatomic) IBOutlet UIButton *contato;
@property (weak, nonatomic) IBOutlet UIButton *contarumamigo;

@property (weak, nonatomic) IBOutlet UIButton *site;

@end

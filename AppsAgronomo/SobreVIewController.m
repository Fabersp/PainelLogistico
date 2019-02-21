//
//  SobreVIewController.m
//  AppsAgronomo
//
//  Created by Fabricio Padua on 29/11/16.
//  Copyright © 2016 Fabricio Padua. All rights reserved.
//

#import "SobreVIewController.h"
#import "SWRevealViewController.h"


@interface SobreVIewController ()

@end

@implementation SobreVIewController

@synthesize ViewApper;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    [self.navigationController.view addSubview:ViewApper];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    self.navigationController.navigationBar.translucent = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

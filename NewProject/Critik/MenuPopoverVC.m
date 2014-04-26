//
//  MenuPopoverVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 4/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "MenuPopoverVC.h"

@interface MenuPopoverVC ()

@end

@implementation MenuPopoverVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews
{
    NSLog(@"MENUPOPOVER %d",self.sendingButtonTag);
    // Do any additional setup after loading the view.
    if (self.sendingButtonTag == 0) {
        // Link Dropbox
        [self.dropboxBtn setTitle:@"Link to Dropbox" forState:UIControlStateNormal];
    }
    else
    {
        // Upload Roster
        [self.dropboxBtn setTitle:@"Upload Roster" forState:UIControlStateNormal];
    }
    
}


@end

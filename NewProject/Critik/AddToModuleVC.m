//
//  AddToModuleVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "AddToModuleVC.h"

@interface AddToModuleVC ()

@end

@implementation AddToModuleVC

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
	// Do any additional setup after loading the view.
    NSLog(@"TAG: %d", self.sendingButtonTag);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

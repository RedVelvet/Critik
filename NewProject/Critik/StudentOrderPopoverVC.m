//
//  StudentOrderPopoverVC.m
//  Critik
//
//  Created by Dalton Decker on 3/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentOrderPopoverVC.h"

@implementation StudentOrderPopoverVC

-(void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePopoverContent:(id)sender {
    
    // Return which order to set students based on button pressed.
    if([sender tag] == 0){
        [self.delegate dismissPopover:@"Alphabetize"];
    }else{
        [self.delegate dismissPopover:@"Randomize"];
    }
    
}

@end

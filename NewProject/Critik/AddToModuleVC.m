//
//  AddToModuleVC.m
//  Critik
//
//  Created by Doug Wettlaufer on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "AddToModuleVC.h"
#define addQuickGrade 6
#define addPredefined 7

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
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
//    NSLog(@"TAG: %d", self.sendingButtonTag);
    switch (self.sendingButtonTag) {
        case addQuickGrade:
            self.addLabel.text = @"Add Scaled Comment";
            break;
        case addPredefined:
            self.addLabel.text = @"Add Checked Comment";
            break;
        default:
            break;
    }
    
}

- (IBAction)cancelPopover:(id)sender {
    // The popover was cancelled so send back an array so that we know what popover was dismissed and just send an empty string
    NSArray *data = [NSArray arrayWithObjects:self.addLabel.text, @"", nil];
    [self.delegate dismissPopover:data];
}

- (IBAction)savePopoverContent:(id)sender {

    // Return an array to the presenting VC, first element tells presenter what popover the array is coming from and the second element is the content of the textfield
    NSArray *data = [NSArray arrayWithObjects:self.addLabel.text, self.addTF.text, nil];
    [self.delegate dismissPopover:data];

}
@end
